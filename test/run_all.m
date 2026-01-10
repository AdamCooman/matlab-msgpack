clear variables
close all
clc

assert(endsWith(pwd,"test"),"you're not running from the right folder")
addpath(fullfile(".."))

enable_coverage = true;

suite = testsuite(fullfile(".."),IncludeSubfolders=true,IncludeSubpackages=true);
runner = testrunner("textoutput");
if enable_coverage
    report_format = matlab.unittest.plugins.codecoverage.CoverageReport("coverageReport");
    coverage_plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder( ...
        fullfile(".."), ...
        IncludeSubfolders=true, ...
        Producing=report_format);
    runner.addPlugin(coverage_plugin)
end
results = runner.run(suite);



