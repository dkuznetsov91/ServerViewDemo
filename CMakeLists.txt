cmake_minimum_required(VERSION 3.16)

project(ServerListDemo)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickControls2
)

qt_add_executable(ServerListDemo
    source/main.cpp
)

qt_add_qml_module(ServerListDemo
    URI ServerListDemo
    VERSION 1.0
    QML_FILES
        qml/ServerView.qml
    SOURCES
        include/ServerListModel.h
        source/ServerListModel.cpp
    RESOURCES
        qml/images/addIcon64.png
        qml/images/personIcon64.png
)

set_target_properties(ServerListDemo PROPERTIES WIN32_EXECUTABLE TRUE)
target_include_directories(ServerListDemo PUBLIC include)

target_link_libraries(ServerListDemo PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)

install(TARGETS ServerListDemo RUNTIME DESTINATION bin)
