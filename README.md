# powershell-logger

A simple PowerShell library for instantiating a logging object. Console output colours can be configured and log files contain ANSI escape codes to which produce colour output in supported applications.

## Install

Copy to powershell path and import the module. Recommend use of object class with "using" keyword rather than "import-module"

``` PowerShell
Copy to path accessible to your project.

e.g. C:\myScript\Modules\powershell-logger
```

## Usage

``` PowerShell
For the example above:
using module '.\Modules\powershell-logger\Logger.psm1'

```

``` PowerShell
using module '.\Logger.psm1'

[Logger] $myLogger = [Logger]::new([boolean] $logToConsole, [boolean] $logToFile, [string] $logFilePath, [string] $logFileName, [Levels] $loggingLevel, $versionID, $operationID, [Environments] $environment)
[Logger] $myLogger.message("Error has occurred").write()

```
## Full Usage Example
``` PowerShell

TBA

```

## Testing

``` PS
TBA

```

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details.

## Credits

- [John Reid](https://github.com/johnnyreid)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
