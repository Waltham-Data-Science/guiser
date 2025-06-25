function testToolbox(varargin)
    installMatBox()
    projectRootDirectory = guisertools.projectdir();
    matbox.tasks.testToolbox(projectRootDirectory, varargin{:})
end
