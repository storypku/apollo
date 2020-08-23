load("@rules_python//python:defs.bzl", "py_binary")
load("@apollo_py3_deps//:requirements.bzl", "requirement")

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "control_info",
    srcs = ["control_info.py"],
    # requirement("tkinter") not listed, provided by apt installed python3-tk
    deps = [
        requirement("numpy"),
        requirement("matplotlib"),
        "//cyber/python/cyber_py3:cyber",
        "//cyber/python/cyber_py3:record",
        "//modules/canbus/proto:chassis_py_pb2",
        "//modules/control/proto:control_cmd_py_pb2",
        "//modules/localization/proto:localization_py_pb2",
        "//modules/planning/proto:planning_py_pb2",
    ],
)
