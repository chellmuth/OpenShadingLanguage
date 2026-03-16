#!/usr/bin/env python

# Copyright Contributors to the Open Shading Language project.
# SPDX-License-Identifier: BSD-3-Clause
# https://github.com/AcademySoftwareFoundation/OpenShadingLanguage

shader_commands = " ".join([
    "-shader upstream upstream_layer",
    "-shader downstream downstream_layer",
    "-connect upstream_layer out_val downstream_layer in_val",
])

# With opt_passref=1 (default): in_val is removed from GroupData.
# GroupData contains only the layer run flags (4 bytes for 2 layers).
command += testshade("{} --print-groupdata".format(shader_commands))

# Verify the layout shows 0 param fields when passref is enabled.
command += testshade("{} --print-groupdata-layout".format(shader_commands))

# With opt_passref=0: in_val remains in GroupData (8 bytes total).
command += testshade("{} --options opt_passref=0 --print-groupdata".format(shader_commands))
