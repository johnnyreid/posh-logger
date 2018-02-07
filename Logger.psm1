Class Logger{

    #determines which level of items to log
    Hidden [Levels]         $pLoggingLevel

    #console logging options
    Hidden [boolean]        $pLogToConsole  = $null

    #logfile options
    Hidden [boolean]        $pLogToFile     = $null

    Hidden [string]         $pLogFileName   = $null
    Hidden [string]         $pLogFilePath   = $null
    
    Hidden [Environments]   $pEnvironment                       #DEVELOPMENT or PRODUCTION
    Hidden [string]         $pOperationID   = $null
    Hidden [string]         $pVersionID     = $null
    Hidden [Levels]         $pLevel
    Hidden [string]         $pValue         = $null
    Hidden [string]         $pMessage       = $null
    Hidden [string]         $pClassName     = $null
    Hidden [string]         $pFunctionName  = $null
    Hidden [string]         $pMethodName    = $null
    Hidden [string]         $pPropertyName  = $null

    Logger()
    {
        $this.Logger($null, $null, $null, $null, $null, $null, $null, $null)
    }
    Logger($operationID)
    {
        $this.Logger($null, $null, $null, $null, $null, $null, $operationID, $null)
    }
    #constructor
    Logger([boolean] $logToConsole, [boolean] $logToFile, [string] $logFilePath, [string] $logFileName, [Levels] $loggingLevel, $versionID, $operationID, [Environments] $environment)
    {
        $this.pEnvironment      = $environment
        $this.pLogToConsole     = $logToConsole
        $this.pLogToFile        = $logToFile
        $this.pLogFilePath      = $logFilePath
        $($this.pLogFilePath).TrimEnd('\','/')

        $this.pLogFileName      = $logFileName
        $this.pLoggingLevel     = $loggingLevel

        $this.pOperationID      = $operationID
        $this.pversionID        = $versionID

        if ( $logToConsole -eq $null )
        {
            $this.pLogToConsole = $true
        }
        if ( $logToFile -eq $null ) 
        {        
            $this.pLogToFile = $false
        }

        if ( -not ($this.pLoggingLevel) )
        {
            $this.pLoggingLevel = [Levels]::INFO
        }
    }

    <#
    .NOTES
    @param enum [string] $operationID
    @return Logger
    #>
    [Logger] operationID([string] $operationID)
    {
        $this.pOperationID = $operationID
        return $this
    }
    <#
    .NOTES
    @param enum [Levels] $level
    @return Logger
    #>
    [Logger] level($level)
    {
        
        $this.pLevel = [Levels] $level
        return $this
    }


      <#
        .NOTES
        @param string $message
        @return Logger
        #>
        [Logger] powershellError($message)
        {
            $this.pMessage = $message
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
    @param string $className
    @return Logger
    #>
    [Logger] className([string] $className)
    {
        $this.pClassName = $className
        return $this
    }
    <#
    .NOTES
    @param string $functionName
    @return Logger
    #>
    [Logger] functionName([string] $functionName)
    {
        
        $this.pFunctionName = $functionName
        return $this
    }
    <#
    .NOTES
    @param string $methodName
    @return Logger
    #>
    [Logger] methodName([string] $methodName)
    {
        
        $this.pmethodName = $methodName
        return $this
    }
    <#
    .NOTES
    @param string $propertyName
    @return Logger
    #>
    [Logger] propertyName([string] $propertyName)
    {
        
        $this.pPropertyName = $propertyName
        return $this
    }

    reset()
    {
        $this.pLevel            = [Levels]::NOTICE
        $this.pMessage          = $null
        $this.pValue            = $null
        $this.pClassName        = $null    
        $this.pFunctionName     = $null
        $this.pPropertyName     = $null
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
    WriteToLogFile([string] $outputMessage)
    {
        if ( -not ($this.pLogToFile) )
        {
            exit
        }
        
        add-content -path "$($this.pLogFilePath)\$($this.pLogFileName)" -value $outputMessage
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
        if ( -not ($this.plevel) )      {$this.pLevel        = [Levels]::NOTICE}
        
        if ( $this.pLevel -gt $this.pLoggingLevel )
        {
            exit
        }

        $outputMessage = ""

        if ( $this.pMessage         )       {$outputMessage    =   "MESSAGE: $($this.pMessage) | $outputMessage"}
        if ( $this.pValue           )       {$outputMessage    =   "VALUE: $($this.pValue) | $outputMessage"}
        if ( $this.pPropertyName    )       {$outputMessage    =   "PROPERTY: $($this.pPropertyName) | $outputMessage"}
        if ( $this.pFunctionName    )       {$outputMessage    =   "FUNCTION: $($this.pFunctionName) | $outputMessage"}
        if ( $this.pMethodName      )       {$outputMessage    =   "METHOD: $($this.pMethodName) | $outputMessage"}
        if ( $this.pClassName       )       {$outputMessage    =   "CLASS: $($this.pClassName) | $outputMessage"}
        # | memoryLoad | cpuLoad    #too slow to include this info!


        $outputMessage = "$($this.pLevel.ToString().PadRight(10))| $outputMessage"

        if ( $this.pEnvironment       )     {$outputMessage    =   "$($this.pEnvironment.ToString().PadRight(12))| $outputMessage"}
        if ( $this.pVersionID       )       {$outputMessage    =   "$($this.pVersionID) | $outputMessage"}
        if ( $this.pOperationID     )       {$outputMessage    =   "$($this.pOperationID) | $outputMessage"}

        $outputMessage = $outputMessage | timestamp

        $outputMessage = $outputMessage.TrimEnd('| ')

        switch ( [Levels] $this.pLevel -as [int] )
        {
            ( [Levels]::EMERGENCY -as [int] )
            {
                if ( $this.pLogToConsole )
                { 
                    $foregroundColor   = "White"
                    $backgroundColor   = "Red"
                    Write-Host $outputMessage -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }

                $outputMessage = $outputMessage | fontColourEmergency
                $this.WriteToLogFile($outputMessage)
            }
            ( [Levels]::ALERT -as [int] )
            {
                if ( $this.pLogToConsole )
                { 
                    $foregroundColor   = "Red"
                    $backgroundColor   = "White"
                    Write-Host $outputMessage -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }

                $outputMessage = $outputMessage | fontColourAlert
                $this.WriteToLogFile($outputMessage)
            }
            ( [Levels]::CRITICAL -as [int] )
            {
                if ( $this.pLogToConsole ) 
                { 
                    $foregroundColor   = "Yellow"
                    $backgroundColor   = "Red"
                    Write-Host $outputMessage -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }

                $outputMessage = $outputMessage | fontColourCritical
                $this.WriteToLogFile($outputMessage)
            }
            ( [Levels]::ERROR -as [int] )
            {
                if ( $this.pLogToConsole ) 
                { 
                    $foregroundColor   = "Red"
                    $backgroundColor   = "Black"
                    Write-Host $outputMessage -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }

                $outputMessage = $outputMessage | fontColourError
                $this.WriteToLogFile($outputMessage)
            }
            ( [Levels]::WARNING -as [int] )
            {
                if ( $this.pLogToConsole )
                { 
                    $foregroundColor   = "Yellow"
                    $backgroundColor   = "Black"
                    Write-Host $outputMessage -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
                }

                $outputMessage = $outputMessage | fontColourWarning
                $this.WriteToLogFile($outputMessage)
            }
            ( [Levels]::NOTICE -as [int] )
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   = "Green"  #     default = "FF00FFFF"
                    $backgroundColor   = "Black"  # transparent
                    Write-Host $outputMessage -ForegroundColor $foregroundColor
                }
                
                $outputMessage = $outputMessage | fontColourNotice
                $this.WriteToLogFile($outputMessage)
            }
            ( [Levels]::INFO -as [int] )
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   =   "Cyan"  #     default = "FF00FFFF"
                    $backgroundColor   = "Blue"  # transparent
                    Write-Host $outputMessage -ForegroundColor $foregroundColor
                }
                
                $outputMessage = $outputMessage | fontColourInfo
                $this.WriteToLogFile($outputMessage)
            }
            ( [Levels]::DEBUG -as [int] )
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   = "Gray"
                    $backgroundColor   = "Blue"
                    Write-host $outputMessage -ForegroundColor $foregroundColor
                }

                $outputMessage = $outputMessage | fontColourDebug       #add colour
                $this.WriteToLogFile($outputMessage)                         #output to log file
            }
            default
            {
                if ( $this.pLogToConsole ) 
                {
                    $foregroundColor   = "Gray"  #     default = "FF00FFFF"
                    #$backgroundColor   = "00FFFFFF"  # transparent
                    Write-host $outputMessage -ForegroundColor $foregroundColor
                }

                $outputMessage = $outputMessage | fontColourInfo
                $this.WriteToLogFile($outputMessage)
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


Enum Levels{
    EMERGENCY                   = 1
    ALERT                       = 2
    CRITICAL                    = 3
    ERROR                       = 4
    WARNING                     = 5
    NOTICE                      = 6
    INFO                        = 7
    DEBUG                       = 8
}
Enum Environments{
    DEVELOPMENT                 = 1
    PRODUCTION                  = 2
}

# Class DefaultMessages
# {
#     $message = @(
#         @{Level = [Levels]::EMERGENCY;             Message = "An EMERGENCY has occurred"           },
#         @{Level = [Levels]::ALERT;                 Message = "An ALERT has been invoked"           },
#         @{Level = [Levels]::CRITICAL;              Message = "A CRITICAL error has occurred"       },
#         @{Level = [Levels]::ERROR;                 Message = "An ERROR has occurred"               },
#         @{Level = [Levels]::WARNING;               Message = "A WARNING has been invoked"          },
#         @{Level = [Levels]::NOTICE;                Message = "A NOTICE has been invoked"           },
#         @{Level = [Levels]::INFO;                  Message = "This INFO has been invoked"          },
#         @{Level = [Levels]::EMERGENCY;             Message = "This DEBUG has been invoked"         }
#     )
    
# }

Export-ModuleMember  -Function * -Variable *