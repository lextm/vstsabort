VSTS/TFS Abort Utility
----------------------
> Story behind the utility can be found in [my blog post](https://blog.lextudio.com/how-to-abort-cancel-a-build-in-vsts-7a41fce5a42c).

To Abort Builds
===============
When a build of multiple tasks is being executed, often we want to abort if
certain conditions do not match expectation.

Abort As Failed
^^^^^^^^^^^^^^^
It is possible to define a verification step and let it fail. Then the whole
build fails.

If you like this way, no need to read further.

Abort As Succeeded
^^^^^^^^^^^^^^^^^^
While the agent is executing the build, you can abort its execution by the
following PowerShell snippet,
```
Write-Host "##vso[task.setvariable variable=agent.jobstatus;]canceled"
Write-Host "##vso[task.complete result=Canceled;]DONE"
```
This build would stop here, and shows as succeeded on dashboard.

If you like this way, no need to read further.

Abort As Cancelled?
^^^^^^^^^^^^^^^^^^^
Instead of marking an aborted build as failed/succeeded, I rather mark them as
cancelled. But the challenge is that you cannot cancel a build from a task by
default. There is simply no such settings in the build definition.

But that's why I created this utility.

How To Use The Utility
======================
Here comes the utility, which can help you abort the build as cancelled.

1. Generate a [Personal Access Token](https://docs.microsoft.com/en-us/vsts/organizations/accounts/use-personal-access-tokens-to-authenticate?view=vsts) and make sure it has "Build (read and execute)" scope selected.
1. Add this token to your pipeline under Variables section as a new variable (for example `system.pat`). Make sure you click "Change variable type to secret" to lock down the value.
1. Add a verification task in your pipeline (Batch Script as example). Make sure `"$(system.pat)"` is passed as Arguments.
1. In the actual batch file (`prepare.abort.bat` in my case), call the utility,

```
echo no change. abort.
set LEXTUDIO_VSTSABORT=TRUE
set SYSTEM_PAT=%~1
powershell -executionpolicy bypass -File abort.ps1
```

> The utility checks an environment variable `LEXTUDIO_VSTSABORT`.
> It also expects PAT to be passed via environment variable `SYSTEM_PAT`.
> All other environment variables are set by VSTS agent.

> The personal access token has a life span (max one year), so it must be replaced with a valid one periodically.

Support
=======
Please report issues in the Issues section.
