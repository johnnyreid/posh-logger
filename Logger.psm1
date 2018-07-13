Class Logger{

    static $messages = @{
        [Levels]::EMERGENCY     =   "An EMERGENCY alert has been raised.";    
        [Levels]::ALERT         =   "An ALERT has been raised.";              
        [Levels]::CRITICAL      =   "A CRITICAL alert has been raised.";  
        [Levels]::ERROR         =   "An ERROR has occurred.";  
        [Levels]::WARNING       =   "A WARNING has been raised.";             
        [Levels]::NOTICE        =   "A NOTICE has been raised.";        
        [Levels]::INFO          =   "An INFO notification has been raised.";  
        [Levels]::DEBUG         =   "A DEBUG notification has been raised.";  
    }

    #operating mode options
    static $PRODUCTION                              = 'PROD'
    static $DEVELOPMENT                             = 'DEV'

    #Constructor options
    Hidden [Levels]     $pLoggingLevelThreshold     = [Levels]::DEBUG       # log all events equal to or greater than this level
    Hidden [boolean]    $pOutputToConsole           = $true                 # output to console
    Hidden [boolean]    $pOutputToFile              = $false                # output to a logfile
    Hidden [string]     $pLogFilepath               = ''                    # path to the log file
    Hidden [string]     $pLogFilename               = ''                    # filename of the log file
    Hidden [string]     $pVersion                   = ''                    # version
    Hidden [string]     $pMode                      = ''                    # DEV or PROD
    Hidden [string]     $pOperationID               = ''                    # a unique/transaction identifier

    # Message Logging options - use the reset() method to do this once the object has been created
    Hidden [Levels]     $pLevel                     = [Levels]::DEBUG       # level of the current log message
    Hidden [string]     $pMessage                   = ''
    Hidden [string]     $pClassName                 = ''
    Hidden [string]     $pMethodName                = ''
    Hidden [string]     $pFieldName                 = ''
    Hidden [string]     $pPropertyPath              = ''
    Hidden [string]     $pFileName                  = ''                    # Optional invocation location details
    Hidden [int]        $pLineNumber                = $null                 # Optional invocation location details
    Hidden              $pValue                     = $null

    #constructor and overloads

    Logger( [string]    $operationID)
    {
        [Logger]::initialise()
        $this.operationID($operationID)
        $this.reset()
    }
    Logger( [Levels]    $loggingLevelThreshold,
            [boolean]   $outputToConsole,
            [boolean]   $outputToFile,
            [string]    $logFilepath,
            [string]    $logFilename,
            [string]    $version,
            [string]    $mode,
            [string]    $operationID
    )
    {
        [Logger]::initialise()
        $this.loggingLevelThreshold($loggingLevelThreshold)
        $this.outputToConsole($outputToConsole)
        $this.outputToFile($outputToFile)
        $this.logFilepath($logFilePath)
        $this.logFilename($logFileName)
        $this.version($version)
        $this.setMode($mode)
        $this.operationID($operationID)
    }

    <#
    .SYNOPSIS
    Initialises this object with additional configuration items.
    #>
    hidden static initialise()
    {
        set-alias __LINE__ -value Get-ScriptLineNumber  -Scope Global | out-null
        set-alias __FILE__ -value Get-ScriptName        -Scope Global | out-null
    }

    <#
    .SYNOPSIS
    Set the loggingLevelThreshold property (optional)
    .PARAMETER loggingLevelThreshold
    The threshold of levels to be logged. Use the built in static properties.
    .NOTES
    @return Logger
    #>
    [Logger] loggingLevelThreshold([Levels] $loggingLevelThreshold)
    {
        $this.pLoggingLevelThreshold = $loggingLevelThreshold

        return $this
    }

    <#
    .SYNOPSIS
    Sets whether to output to console
    .PARAMETER outputToConsole
    Boolean
    .NOTES
    @return Logger
    #>
    [Logger] outputToConsole()
    {
        return $this.outputToConsole($true)
    }
    [Logger] outputToConsole([bool] $outputToConsole)
    {
        $this.pOutputToConsole = $outputToConsole

        return $this
    }

    <#
    .SYNOPSIS
    Sets whether to output to file
    .PARAMETER outputToFile
    Boolean
    .NOTES
    @return Logger
    #>
    [Logger] outputToFile()
    {
        return $this.outputToFile($true)
    }
    [Logger] outputToFile([bool] $outputToFile)
    {
        $this.pOutputToFile = $outputToFile

        return $this
    }

    <#
    .SYNOPSIS
    Set the logFilePath property (just the local path, do not include the filename).
    .PARAMETER logFilePath
    The local path of the log file. Do not include the filename.
    .NOTES
    Trims any slashes off the end of the path string, if present.
    @return Logger
    #>
    [Logger] logFilepath([string] $logFilepath)
    {
        $this.plogFilepath = $($logFilepath).TrimEnd('\','/')

        return $this
    }

    <#
    .SYNOPSIS
    Set the logFileName property (not the full path, just the filename of the log file)
    .PARAMETER logFilename
    The log filename. Do not include the path.
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
    Set the version property (optional)
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
    Set the mode property (optional)
    .PARAMETER mode
    The mode property ('PROD' or 'DEV')
    static properties [Logger]::PRODUCTION and [Logger]::DEVELOPMENT have been included for this property.
    .NOTES
    static properties [Logger]::PRODUCTION and [Logger]::DEVELOPMENT have been included.
    @return Logger
    #>
    [Logger] setMode([string] $mode)
    {
        $this.pMode = $mode

        return $this
    }

    <#
    .SYNOPSIS
    Set the operationID property (optional)
    .PARAMETER operationID
    A unique ID for the operation/transaction
    .NOTES
    @return Logger
    #>
    [Logger] operationID([string] $operationID)
    {
        $this.pOperationID = $operationID

        return $this
    }

    <#
    .SYNOPSIS
    Set the level property (optional)
    .PARAMETER level
    Use the built in enum levels (static enum [Logger.Levels] has been included for this.)
    .NOTES
    @param enum [Levels] $level
    @return Logger
    #>
    [Logger] level([Levels] $level)
    {
        $this.pLevel = $level

        return $this
    }

    <#
    .SYNOPSIS
    Set the message property (optional)
    .PARAMETER message
    The message that is to be included in the log output.
    .NOTES
    @return Logger
    #>
    [Logger] message([STRING] $message)
    {
        $this.pMessage = $message

        return $this
    }

    <#
    .SYNOPSIS
    Set the className property (optional)
    .PARAMETER className
    The name of the current class, if this is to be included in the log output.
    .NOTES
    @return Logger
    #>
    [Logger] className($className)
    {
        $this.pClassName = $className

        return $this
    }

    <#
    .SYNOPSIS
    Set the methodName property (optional)
    .PARAMETER className
    The name of the current method, if this is to be included in the log output.
    .NOTES
    @return Logger
    #>
    [Logger] methodName($methodName)
    {
        $this.pMethodName = $methodName

        return $this
    }

    <#
    .SYNOPSIS
    Set the fieldName property (optional)
    .PARAMETER className
    The name of the current field, if this is to be included in the log output.
    .NOTES
    @return Logger
    #>
    [Logger] fieldName($fieldName)
    {
        $this.pFieldName = $fieldName

        return $this
    }
 
    <#
    .SYNOPSIS
    Set the propertyPath property (optional)
    .PARAMETER className
    The path of the current property, if this is to be included in the log output.
    .NOTES
    @return Logger
    #>
    [Logger] propertyPath([string] $propertyPath)
    {
        $this.pPropertyPath = $propertyPath

        return $this
    }

    <#
    .SYNOPSIS
    Set the value property (optional)
    .PARAMETER className
    The currentl value, if this is to be included in the log output.
    .NOTES
    @return Logger
    #>
    [Logger] value($value)
    {
        $this.pValue = $value
 
        return $this
    }

    <#
    .SYNOPSIS
    Sets the fileName property (optional)
    .PARAMETER fileName
    The name of the file which will receive commits. Do not include the path.
    .EXAMPLE
    $myLogger = $myLogger.fileName("logfile.log")
    .NOTES
    @return Logger
    #>
    [Logger] fileName([string] $fileName)
    {
        $this.pFileName = $fileName

        return $this
    }

    <#
    .SYNOPSIS
    Sets the lineNumber property (optional)
    .NOTES
    @param int $lineNumber
    @return Logger
    #>
    [Logger] lineNumber([int] $lineNumber)
    {
        
        $this.pLineNumber = $lineNumber

        return $this
    }

    <#
    .SYNOPSIS
    Reset the basic message output details, not the logger configuration.
    .EXAMPLE
    $myLogger.reset()
    .NOTES
    @return Logger
    #>
    [Logger] reset()
    {
        $this.plevel        = [Levels]::DEBUG
        $this.pMessage      = ''
        $this.pClassName    = ''
        $this.pMethodName   = ''
        $this.pFieldName    = ''
        $this.pPropertyPath = ''
        $this.pFileName     = ''
        $this.pLineNumber   = $null
        $this.pValue        = $null

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


    <#
    .SYNOPSIS
    Append a message to the log file.
    .PARAMETER message
    The full message to be appended to the file.
    .EXAMPLE
    $myLogger.commitToLogFile("message to be appended")
    #>
    Hidden commitToLogFile([string] $message)
    {
        if ( $this.pOutputToFile -ne $true )
        {
            exit
        }
        if ( [string]::IsNullOrEmpty($this.pLogFilePath) -or [string]::IsNullOrEmpty($this.pLogFileName) )
        {
            exit
        }

        $success = $false
        do
        {
            try
            {
                add-content -path "$($this.pLogFilePath)\$($this.pLogFileName)" -value $message
                $success = $true
            } 
            catch
            {
                Start-Sleep -m 1
            }
        }
        while ( $success = $false )
    }

    <#  
    .SYNOPSIS
    Compile the final message form and output to console and/or file, depending what has been set.
    This is the final command after the logger has been configured and message set up.
    .EXAMPLE
    $myLogger.commit()
    #>
    commit()
    {
        if ( -not ($this.pLevel)    )       { $this.pLevel  = [Levels]::NOTICE }
        
        if ( $this.pLevel -lt $this.pLoggingLevelThreshold )
        {
            exit
        }

        $message = ""

        if ( $this.pLineNumber      )       { $message      =   "LINE: $($this.pLineNumber) | $message" }
        if ( $this.pFileName        )       { $message      =   "FILE: $($this.pFileName) | $message" }
        if ( $this.pValue           )       { $message      =   "VALUE: $($this.pValue.ToString()) | $message" }
        if ( $this.pFieldName       )       { $message      =   "FIELD: $($this.pFieldName) | $message" }
        if ( $this.pPropertyPath    )       { $message      =   "PROPERTY: $($this.pPropertyPath) | $message" }
        if ( $this.pMethodName      )       { $message      =   "METHOD: $($this.pMethodName) | $message" }
        if ( $this.pClassName       )       { $message      =   "CLASS: $($this.pClassName) | $message" }
        # | memoryLoad | cpuLoad    #too slow to include this info!

        if ( $this.pMessage )
        { 
            $message      =     "$($this.pMessage) | $message"
        }
        else
        {
            $message      =     "$($([Logger]::messages[$this.pLevel]))    | $message"
        }

        $message = "$($this.pLevel.ToString().PadRight(10))| $message"

        if ( $this.pMode     )       { $message      =   "$($this.pMode.ToString().PadRight(4)) | $message" }
        # if ( $this.pVersion         )       { $message      =   "$($this.pVersion) | $message" }
        if ( $this.pOperationID     )       { $message      =   "$($this.pOperationID) | $message" }

        $message = $message | timestamp

        $message = $message.TrimEnd('| ')   #trim any junk off the end of the message

        switch ( $this.pLevel )
        {
            ( [Levels]::EMERGENCY )
            {
                if ( $this.pOutputToConsole )
                { 
                    $foregroundColor   = "White"
                    $backgroundColor   = "Red"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourEmergency
                $this.commitToLogFile($message)
            }
            ( [Levels]::ALERT )
            {
                if ( $this.pOutputToConsole )
                { 
                    $foregroundColor   = "Red"
                    $backgroundColor   = "White"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourAlert
                $this.CommitToLogFile($message)
            }
            ( [Levels]::CRITICAL )
            {
                if ( $this.pOutputToConsole ) 
                { 
                    $foregroundColor   = "Yellow"
                    $backgroundColor   = "Red"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourCritical
                $this.CommitToLogFile($message)
            }
            ( [Levels]::ERROR )
            {
                if ( $this.pOutputToConsole ) 
                { 
                    $foregroundColor   = "Red"
                    $backgroundColor   = "Black"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourError
                $this.CommitToLogFile($message)
            }
            ( [Levels]::WARNING )
            {
                if ( $this.pOutputToConsole )
                { 
                    $foregroundColor   = "Yellow"
                    $backgroundColor   = "Black"
                    Write-Host $message -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }
                $message = $message | fontColourWarning
                $this.CommitToLogFile($message)
            }
            ( [Levels]::NOTICE )
            {
                if ( $this.pOutputToConsole ) 
                {
                    $foregroundColor   = "Green"  #     default = "FF00FFFF"
                    $backgroundColor   = "Black"  # transparent
                    Write-Host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourNotice
                $this.CommitToLogFile($message)
            }
            ( [Levels]::INFO )
            {
                if ( $this.pOutputToConsole ) 
                {
                    $foregroundColor   =   "Cyan"  #     default = "FF00FFFF"
                    $backgroundColor   = "Blue"  # transparent
                    Write-Host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourInfo
                $this.CommitToLogFile($message)
            }
            ( [Levels]::DEBUG )
            {
                if ( $this.pOutputToConsole ) 
                {
                    $foregroundColor   = "Gray"
                    $backgroundColor   = "Blue"
                    Write-host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourDebug       #add colour
                $this.CommitToLogFile($message)              #output to log file
            }
            default
            {
                if ( $this.pOutputToConsole ) 
                {
                    $foregroundColor   = "Gray"  #     default = "FF00FFFF"
                    #$backgroundColor   = "00FFFFFF"  # transparent
                    Write-host $message -ForegroundColor $foregroundColor
                }
                $message = $message | fontColourInfo
                $this.CommitToLogFile($message)
            }
        }
        $this.reset()
    }
}

#linux log colours explained: https://automationrhapsody.com/coloured-log-files-linux/
filter fontColourEmergency{"[1;37m[41m$_[0m"} #fore = RED, back = DEFAULT, self = BOLD
filter fontColourAlert{"[1;37m[43m$_[0m"} #fore = RED, back = DEFAULT, self = BOLD
filter fontColourCritical{"[0;31m[49m$_[0m"} #fore = RED, back = DEFAULT, self = BOLD

filter fontColourError{"[0;31m[49m$_[0m"} #fore = RED, back = DEFAULT, self = DEFAULT
filter fontColourWarning{"[0;33m[49m$_[0m"} #fore = WHITE, back = YELLOW, self = DEFAULT

filter fontColourNotice{"[0;36m[49m$_[0m"} #fore = GREEN, back = DEFAULT, self = DEFAULT0;36


filter fontColourInfo{"[0;32m[49m$_[0m"} #fore = GREEN, back = DEFAULT, self = DEFAULT

filter fontColourDebug{"[0;30m[49m$_[0m"} #fore = DARK_GRAY, back = DEFAULT, self = DEFAULT

#prefix filters
filter timestamp {"$(Get-Date -Format "yyyy-MM-dd HH:mm:ss:ffffff") | $_" }

function Get-ScriptLineNumber { return [int] $MyInvocation.ScriptLineNumber }
function Get-ScriptName { return [string] $MyInvocation.ScriptName }

Enum Levels{
    EMERGENCY                   = 8
    ALERT                       = 7
    CRITICAL                    = 6
    ERROR                       = 5
    WARNING                     = 4
    NOTICE                      = 3
    INFO                        = 2
    DEBUG                       = 1
}

Export-ModuleMember  -Function * -Variable *