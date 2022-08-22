FROM osrf/ros:noetic-desktop-full

RUN apt-get update \
    && apt-get install -y build-essential python3-rosdep python3-catkin-lint python3-catkin-tools python3-osrf-pycommon software-properties-common tmux wget

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - \
    && apt-get update \
    && apt-get install libgazebo11-dev libignition-common3-dev libignition-math-dev -y

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-key C8B3A55A6F3EFCDE \
    && add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" \
    && sudo apt-get update \
    && apt-get install librealsense2-dev --allow-unauthenticated -y \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

ENV ROS_DISTRO noetic

COPY . /catkin_ws
COPY .tmux.conf /root
WORKDIR /catkin_ws

RUN rosdep update && DEBIAN_FRONTEND=noninteractive rosdep install --from-paths src -i -y --rosdistro noetic \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin init && \
    catkin config -j 1 -p 1 && \
    catkin build -DCMAKE_BUILD_TYPE=Release --no-notify"

RUN echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc
