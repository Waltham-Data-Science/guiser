function codecheckToolbox()
    installMatBox()
    projectRootDirectory = {{namespace_name}}tools.projectdir();
    matbox.tasks.codecheckToolbox(projectRootDirectory)
end
