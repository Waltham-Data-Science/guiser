function testToolbox(varargin)
    installMatBox()
    projectRootDirectory = {{namespace_name}}tools.projectdir();
    matbox.tasks.testToolbox(projectRootDirectory, varargin{:})
end
