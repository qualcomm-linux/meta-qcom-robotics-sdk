inherit robotics-package

# Remove these to disable visualization functions in nav2(including gazebo), meanwhile solve the compile problems.
ROS_EXEC_DEPENDS:remove = " \
    slam-toolbox \
    nav2-minimal-tb4-sim \
    nav2-minimal-tb3-sim \
    ros-gz-sim \
    ros-gz-bridge \
"
