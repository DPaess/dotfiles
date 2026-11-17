-- filetypes Neovim does not detect on its own
vim.filetype.add({
    extension = {
        -- ROS: launch files, Gazebo worlds and models, robot descriptions
        launch = "xml",
        world = "xml",
        sdf = "xml",
        urdf = "xml",
        xacro = "xml",
        -- go html/template
        tmpl = "html",
    },
    filename = {
        [".localrc"] = "sh",
    },
})
