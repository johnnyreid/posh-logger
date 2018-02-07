Class Logger{

    static $EMERGENCY                   = @(7, 'EMERGENCY')
    static $ALERT                       = @(6, 'ALERT')
    static $CRITICAL                    = @(5, 'CRITICAL')
    static $GENERAL_ERROR               = @(4, 'ERROR')
    static $WARNING                     = @(3, 'WARNING')
    static $NOTICE                      = @(2, 'NOTICE')
    static $INFO                        = @(1, 'INFO')
    static $DEBUG                       = @(0, 'DEBUG')

    # static $EMERGENCY_MESSAGE           = 'An EMERGENCY has occurred.'
    # static $ALERT_MESSAGE               = 'An ALERT has been raised.'
    # static $CRITICAL_MESSAGE            = 'A CRITICAL error has occurred.'
    # static $GENERAL_ERROR_MESSAGE       = 'A GENERAL ERROR has occurred.'
    # static $WARNING_MESSAGE             = 'A WARNING has been raised.'
    # static $NOTICE_MESSAGE              = 'A NOTICE has been raised.'
    # static $INFO_MESSAGE                = 'INFO has been raised.'
    # static $DEBUG_MESSAGE               = 'DEBUG has been raised.'

    #opererating environment options
    static $PRODUCTION                  = 'PRODUCTION'
    static $DEVELOPMENT                 = 'DEVELOPMENT'

    #Constructor options
    Hidden [array]      $pLoggingLevel  = [Logger]::INFO        # log all events equal to or greater than this level

    Hidden [boolean]    $pLogToConsole  = $true                 # output to console?

    Hidden [boolean]    $pLogToFile     = $false                # output to a logfile?

    Hidden [string]     $pLogFilepath   = ''                    # path to the log file

    Hidden [string]     $pLogFilename   = ''                    # filename of the log file

    Hidden [string]     $pVersion       = ''                    # version

    Hidden [string]     $pEnvironment   = ''                    # DEVELOPMENT or PRODUCTION

    Hidden [string]     $pOperationID   = ''                    # a unique/transaction identifier

    # Message Logging options - use the reset() method to do this once the object has been created
    Hidden [array]      $pLevel         = [Logger]::DEBUG       # level of the current log message

    Hidden [string]     $pMessage       = ''

    Hidden [string]     $pFieldName     = ''

    Hidden              $pValue         = $null

    Hidden [string]     $pPropertyPath  = ''

    Hidden [string]     $pFile          = ''                    # Optional invocation location details

    Hidden [int]        $pLine          = $null                 # Optional invocation location details

    #constructors
    Logger()
    {
    }
    Logger( [string]    $operationID)
    {
        $this.operationID($operationID)
    }
    Logger( [array]     $loggingLevel, 
            [boolean]   $logToConsole, 
            [boolean]   $logToFile, 
            [string]    $logFilepath, 
            [string]    $logFilename, 
            [string]    $version, 
            [string]    $environment, 
            [string]    $operationID
    )
    {
        $this.loggingLevel($loggingLevel)
        $this.logToConsole($logToConsole)
        $this.logToFile($logToFile)
        $this.logFilepath($logFilePath)
        $this.logFilename($logFileName)
        $this.version($version)
        $this.environment($environment)
        $this.operationID($operationID)
    }

    <#
    .SYNOPSIS
    Set the loggingLevel property
    .PARAMETER loggingLevel
    The threshold of levels to be logged. Use the built in static properties.
    .NOTES
    @return Logger
    #>
    [Logger] loggingLevel([array] $loggingLevel)
    {
        $this.pLoggingLevel = $loggingLevel

        return $this
    }

    <#
    .SYNOPSIS
    Output to console?
    .PARAMETER logToConsole
    Boolean
    .NOTES
    @return Logger
    #>
    [Logger] logToConsole()
    {
        return $this.logToConsole($true)
    }
    [Logger] logToConsole([bool] $logToConsole)
    {
        $this.pLogToConsole = $logToConsole

        return $this
    }

    <#
    .SYNOPSIS
    Output to file?
    .PARAMETER logToFile
    Boolean
    .NOTES
    @return Logger
    #>
    [Logger] logToFile()
    {
        return $this.logToFile($true)
    }
    [Logger] logToFile([bool] $logToFile)
    {
        $this.pLogToFile = $logToFile

        return $this
    }

    <#
    .SYNOPSIS
    Set the logFilePath property
    .PARAMETER version
    The logFilePath property
    .NOTES
    Trims any slashes off the end of the path string, if present
    @return Logger
    #>
    [Logger] logFilepath([string] $logFilepath)
    {
        $this.plogFilepath = $($logFilepath).TrimEnd('\','/')

        return $this
    }

    <#
    .SYNOPSIS
    Set the logFile property (Not the full path, just the filename of the log file)
    .PARAMETER version
    The logFile property
    .NOTES
    Not the full path, just the filename of the log file
    @return Logger
    #>
    [Logger] logFilename([string] $logFilename)
    {
        $this.pLogFilename = $logFilename

        return $this
    }

    <#
    .SYNOPSIS
    Set the version property
    .PARAMETER version
    The version property (version ID)
    .NOTES
    @return Logger
    #>
    [Logger] version([string] $version)
    {
        $this.pVersion = $version

        return $this
    }

    <#
    .SYNOPSIS
    Set the environment property
    .PARAMETER environment
    The environment property (production or development)
    .NOTES
    @return Logger
    #>
    [Logger] environment([string] $environment)
    {
        $this.pEnvironment = $environment

        return $this
    }

    <#
    .SYNOPSIS
    Set the operationID property
    .PARAMETER operationID
    A unique ID for the operation
    .NOTES
    @return Logger
    #>
    [Logger] operationID([string] $operationID)
    {
        $this.pOperationID = $operationID

        return $this
    }

    <#
    .PARAMETER level
    Use the built in static levels
    .NOTES
    @param array $level
    @return Logger
    #>
    [Logger] level([array] $level)
    {
        $this.pLevel = $level

        return $this
    }

    <#
    .NOTES
    @param string $message
    @return Logger
    #>
    [Logger] message($message)
    {
        $this.pMessage = $message

        return $this
    }

    <#
    .NOTES
    @param string $fieldName
    @return Logger
    #>
    [Logger] fieldName($fieldName)
    {
        $this.pFieldName = $fieldName

        return $this
    }

    <#
    .NOTES
    @param mixed $value
    @return Logger
    #>
    [Logger] value($value)
    {
        $this.pValue = $value
 
        return $this
    }
 
    <#
    .NOTES
    @param string $propertyPath
    @return Logger
    #>
    [Logger] propertyPath([string] $propertyPath)
    {
        $this.pPropertyPath = $propertyPath

        return $this
    }

    <#
    .NOTES
    @param string $file
    @return Logger
    #>
    [Logger] file([string] $file)
    {
        $this.pFile = $file

        return $this
    }
    <#
    .NOTES
    @param int $line
    @return Logger
    #>
    [Logger] line([int] $line)
    {
        
        $this.pLine = $line

        return $this
    }

    <#
    .SYNOPSIS
    Reset the basic message output details
    .NOTES
    @return Logger
    #>
    [Logger] reset()
    {
        $this.level([Logger]::DEBUG)
        $this.message('')
        $this.fieldName('')
        $this.value($null)
        $this.propertyPath('')
        $this.file('')
        $this.line($null)

        return $this
    }

   #https://technet.microsoft.com/en-us/library/ee692799.aspx
        #(Get-Host).PrivateData| Format-List -Property *    print all the props out
        
        #Available colours:
        #    - Black
        #    - Blue
        #    - Cyan
        #    - DarkBlue
        #    - DarkCyan
        #    - DarkGray
        #    - DarkGreen
        #    - DarkMagenta
        #    - DarkRed
        #    - DarkYellow
        #    - Gray
        #    - Green
        #    - Magenta
        #    - Red
        #    - White
        #    - Yellow


    # Output current data to a file 
    Hidden WriteToLogFile([string] $message)
    {
        if ( $this.pLogToFile -ne $true )
        {
            exit
        }
        if ( [string]::IsNullOrEmpty($this.pLogFilePath) -or [string]::IsNullOrEmpty($this.pLogFileName) )
        {
            exit
        }
        add-content -path "$($this.pLogFilePath)\$($this.pLogFileName)" -value $message
    }

    # Write()
    # {
    #     $this.WriteIt($null, $null, $null, $null, $null)
    # }
    # Write([Levels] $level,$message)
    # {
    #     $this.WriteIt($level, $message, $null, $null, $null)
    # }
    # [Levels] $level, $message, $className, $functionName, $propertyName
    # Output current data to the console
    Write()
    {
        if ( -not ($this.pLevel) )      {$this.pLevel        = [Logger]::NOTICE}
        
        if ( $this.pLevel[0] -lt $this.pLoggingLevel[0] )
        {
            exit
        }

        $message = ""

        if ( $this.pMessage         )       {$message    =   "MESSAGE: $($this.pMessage)            | $message"}
        if ( $this.pValue           )       {$message    =   "VALUE: $($this.pValue.ToString())     | $message"}
        if ( $this.pFieldName       )       {$message    =   "FIELDNAME: $($this.pPropertyName)     | $message"}
        if ( $this.pPropertyPath    )       {$message    =   "PROPERTYPATH: $($this.pPropertyPath)  | $message"}
        if ( $this.pLine            )       {$message    =   "LINE: $($this.pLine)                  | $message"}
        if ( $this.pFile            )       {$message    =   "FILE: $($this.pFile)                  | $message"}
        # | memoryLoad | cpuLoad    #too slow to include this info!


        $message = "$($this.pLevel[1].ToString().PadRight(10))| $message"

        if ( $this.pEnvironment     )       {$message    =   "$($this.pEnvironment.ToString().PadRight(12))| $message"}
        if ( $this.pVersion         )       {$message    =   "$($this.pVersion)                     | $message"}
        if ( $this.pOperationID     )       {$message    =   "$($this.pOperationID)                 | $message"}

        $message = $message | timestamp

        $message = $message.TrimEnd('| ')   #trim any junk off the end of the message

        switch ( $this.pLevel[0] )
        {
            ( [Logger]::EMERGENCY[0] )
            {
                if ( $this.pLogToConsole )
                { 
                    $foregroundColor   = "White"
                    $backgroundColor   = "Red"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourEmergency
                $this.WriteToLogFile($message)
            }
            ( [Logger]::ALERT[0] )
            {
                if ( $this.pLogToConsole )
                { 
                    $foregroundColor   = "Red"
                    $backgroundColor   = "White"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourAlert
                $this.WriteToLogFile($message)
            }
            ( [Logger]::CRITICAL[0] )
            {
                if ( $this.pLogToConsole ) 
                { 
                    $foregroundColor   = "Yellow"
                    $backgroundColor   = "Red"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourCritical
                $this.WriteToLogFile($message)
            }
            ( [Logger]::ERROR[0] )
            {
                if ( $this.pLogToConsole ) 
                { 
                    $foregroundColor   = "Red"
                    $backgroundColor   = "Black"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourError
                $this.WriteToLogFile($message)
            }
            ( [Logger]::WARNING[0] )
            {
                if ( $this.pLogToConsole )
                { 
                    $foregroundColor   = "Yellow"
                    $backgroundColor   = "Black"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourWarning
                $this.WriteToLogFile($message)
            }
            ( [Logger]::NOTICE[0] )
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   = "Green"  #     default = "FF00FFFF"
                    $backgroundColor   = "Black"  # transparent
                    Write-Host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourNotice
                $this.WriteToLogFile($message)
            }
            ( [Logger]::INFO[0] )
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   =   "Cyan"  #     default = "FF00FFFF"
                    $backgroundColor   = "Blue"  # transparent
                    Write-Host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourInfo
                $this.WriteToLogFile($message)
            }
            ( [Logger]::DEBUG[0] )
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   = "Gray"
                    $backgroundColor   = "Blue"
                    Write-host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourDebug       #add colour
                $this.WriteToLogFile($message)                         #output to log file
            }
            default
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   = "Gray"  #     default = "FF00FFFF"
                    #$backgroundColor   = "00FFFFFF"  # transparent
                    Write-host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourInfo
                $this.WriteToLogFile($message)
            }
        }
        $this.reset()
    }
}

#linux log colours explained: https://automationrhapsody.com/coloured-log-files-linux/
filter fontColourEmergency{"[1;31m[40m$_[0m"} #fore = RED, back = DEFAULT, self = BOLD
filter fontColourAlert{"[1;31m[43m$_[0m"} #fore = RED, back = DEFAULT, self = BOLD
filter fontColourCritical{"[1;31m[45m$_[0m"} #fore = RED, back = DEFAULT, self = BOLD

filter fontColourError{"[0;31m[49m$_[0m"} #fore = RED, back = DEFAULT, self = DEFAULT
filter fontColourWarning{"[0;46m[33m$_[0m"} #fore = WHITE, back = YELLOW, self = DEFAULT
filter fontColourNotice{"[0;35m[49m$_[0m"} #fore = GREEN, back = DEFAULT, self = DEFAULT
filter fontColourInfo{"[0;32m[49m$_[0m"} #fore = GREEN, back = DEFAULT, self = DEFAULT
filter fontColourDebug{"[0;30m[49m$_[0m"} #fore = DARK_GRAY, back = DEFAULT, self = DEFAULT

#prefix filters
filter timestamp {"$(Get-Date -Format "yyyy-MM-dd HH:mm:ss:ffffff") | $_"}

Export-ModuleMember  -Function * -Variable *