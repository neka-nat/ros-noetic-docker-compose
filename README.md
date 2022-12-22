#  ros-noetic-docker-compose

## What is installed in the Docker image

* ROS noetic
* gazebo
* librealsense2
* tmux

## Build
Copy the complete code of this repository into the top directory of the catkin workspace.

```sh
cd catkin_ws
git subtree add --prefix=./ https://github.com/neka-nat/ros-noetic-docker-compose.git master
docker-compose -f docker-compose.gui.yml up -d
docker exec -it rosnoetic bash
catkin build
```

