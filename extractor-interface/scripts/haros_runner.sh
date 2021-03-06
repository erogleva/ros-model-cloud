#!/bin/bash

# Arguments:
#   1: Package name
#   2: Node name or launch file name
#   3: Type of the request: either 'launch' or 'node'
#   4: Path to the folder where the resulting model files should be stored
#   5: Path to the ROS workspace 
# Returns:
#   (None)

scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "${5}" || exit # path to the catkin workspace
source devel/setup.bash

rosdep install -y -i -r --from-path src

if [[ ${3} = 'launch' ]];
then
   (cd src && "${scripts_dir}"/setup_ws_depends.sh "$1")

   "${scripts_dir}"/../catkin/bin/catkin_make_isolated --only-pkg-with-deps "$1" --continue-on-failure -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_CXX_COMPILER=/usr/bin/clang++-3.8 --merge

   mkdir build 2>/dev/null && touch build/compile_commands.json
   cat build_isolated/*/compile_commands.json >> build/compile_commands.json
   sed -i -e 's/\]\[/\,/g' build/compile_commands.json
   launch_path="$( find src -name "$2" )"

   # Get the output of roslaunch-dump
   dump="$( python "${scripts_dir}"/roslaunch-dump "${launch_path}" )"

   # Replace the launch file by the output of roslaunch-dump
   echo "${dump}" > "${launch_path}"

else
   catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1
fi

haros init
python "${scripts_dir}"/ros_model_extractor.py --package "$1" --name "$2" --"${3}" --model-path "${4}"
