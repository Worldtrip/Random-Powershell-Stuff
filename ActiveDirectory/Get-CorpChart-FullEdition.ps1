<#
  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
 #>

 Function Get-Corpchart-FullEdition {

<#

.Synopsis
Draws a chart. Requires both .NET 3.5 and Microsoft Chart Controls for Microsoft .NET Framework 3.5 (http://www.microsoft.com/en-us/download/details.aspx?id=14422)

.DESCRIPTION
Draws a chart. Requires both .NET 3.5 and Microsoft Chart Controls for Microsoft .NET Framework 3.5 (http://www.microsoft.com/en-us/download/details.aspx?id=14422).

Input data:
 - hashtable 
 - array of objects. In this case, you have to supply which are the two properties of the object to draw by supplying parameters (-obj_key and -obj-value)

Parameter Sets:
There are two parameter sets for the function. One that accepts (Type) Parameter, and one that accepts a (chartTheme). In case of (Type), you will specify a type of the chart (PowerShell intellisense will populate the list of types for you). In case of (chartTheme), you will specify one of the available themes that the author already wrote for you. (chartTheme) takes an integer to specify the theme ID, and PowerShell intellisense will also help you figure out the available themes.


In case of extreme customization, you can specify the Type that you want, and supply a hashtable with extra customization properties. Look at the examples to learn more.


Versioning:
    - Version 1.0 written 25 November 2013 : first version.
    - Version 2.0 written 30 November 2013 : The following are the new features:
        - The function now takes array of objects in addition to hashtable.
        - Sortable data option via -sort parameter.
        - More themes including 3D charts.
        - Fix label alignment via -fix_label_alignment parameter.
        - Exposing X and Y axis intervals via parameters.
        - Show data as percentage via -show_percentage_pie parameter.
        - Collected threshold to group data items below the threshold into one item called 'Others'.
        - Customizing chart data column colors via -chart_color parameter.
        - Dynamic dimension depending on the number of items in the input data.
    -Version 3.0 : Bug Fixes
   


.PARAMETER Data
Hash table or array of objects. Required parameter.

.PARAMETER Filepath
File path to save the chart like "c:\Chart1.PNG". Required parameter.

.PARAMETER Type 
Chart type. Default is 'column'. Famous types are 'column', 'bar', 'pie', 'doughnut'. PowerShell intellisense will populate the list of types for you.

.PARAMETER Title_text
Chart title. Default is empty title.

.PARAMETER Chartarea_Xtitle.  
Chart X Axis title. Default is empty title.

.PARAMETER Chartarea_Ytitle  
Chart Y Axis title. Default is empty title.

.PARAMETER Xaxis_Interval  
Enter X Axis interval. Default is 1.

.PARAMETER Yaxis_Interval  
Enter Y Axis interval. Usually you do not need to use this parameter.

.PARAMETER Chart_color  
Enter chart column color. Only in case of 'column' or 'bar' chart types.

.PARAMETER Title_color  
Enter chart title color. Default is 'red'.

.PARAMETER ChartTheme  
Instead of using the -Type parameter to specify chart type, use one of the available themes. Values to this parameter is integer representing the theme ID. PowerShell intellisense will populate the list theme IDs available.

.PARAMETER CustomLook  
Very advance option. Only applicable of you use the -Type parameter. Customize the chart by providing hashtable of properties. Look at the examples for more info.

.PARAMETER CollectedThreshold  
Enter a threshold that all data values below it will be grouped as one item named 'Others'. This parameter takes an integer from 1 to 100.

.PARAMETER Sort  
Sort the data option. Values are either 'asc' or 'dsc'.

.PARAMETER IsvalueShownAsLabel
Switch parameter to indicate values appear as a label on the chart.

.PARAMETER ShowHighLow
Switch parameter to indicate that the maximum and minimum values are highlighted in the chart.

.PARAMETER ShowLegend
Switch parameter to determine if legend should be added to the chart.

.PARAMETER Obj_key
This parameter is required when the input data type is array of objects. This represents the name of the object properties to be used as X Axis data.

.PARAMETER Obj_value
This parameter is required when the input data type is array of objects. This represents the name of the object properties to be used as Y Axis data.

.PARAMETER Append_date_title
Append the current data to the title.

.PARAMETER Fix_label_alignment
Only applicable if the chart type is Pie or Doughnut. If the data labels in the chart are overlapping, use the switch to fix it.

.PARAMETER Show_percentage_pie
Only applicable if the chart type is Pie or Doughnut. This will show the data labels on the chart as percentages instead of actual data values.




.EXAMPLE
Chart by supplying hashtable as input. Since no chart type is provided and no chart themes are used, then the default chart type is 'column'.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png"

.EXAMPLE
Chart by supplying array of objects as input. We are interested in the Name and Population properties of the input objects.
In this case, we should also use the -obj_key and -obj_value parameters to tell the function which properties to draw. Default chart type 'column' is used.
PS C:\> Get-Corpchart-FullEdition -data $array_of_city_objects -filepath "c:\chart.png" -obj_key "Name" -obj_value "Population"

.EXAMPLE
Specifying chart type as pie chart type.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type pie

.EXAMPLE
Specifying chart type as pie chart type. legend is shown.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type pie -showlegend

.EXAMPLE
Specifying chart type as SplineArea chart type.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type SplineArea

.EXAMPLE
Specifying chart type as bar chart type, and specifying the title for the chart and x/y axis.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type Bar -title_text "people per country" -chartarea_Xtitle "cities" -chartarea_Ytitle "population"

.EXAMPLE
Specifying chart type as column chart type. Applying the -showHighLow switch to highlight the max and min values with different colors.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type column -showHighLow

.EXAMPLE
Apply one of the themes available to you. You cannot set the chart type when you apply the chartTheme parameter as this is done automatically for you. Parameter (chartThemes) takes an integer which represents the theme ID. PowerShell intellisense will help you see the available themes and their IDs.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -chartTheme 3

.EXAMPLE
Apply extra customization via external customization hashtable.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}.
PS C:\> $hashtable=@{"PieLabelStyle"="Outside";"PieLineColor"="Black";"DoughnutRadius"="60";"PieDrawingStyle"="softedge"}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type Doughnut -customLook $hashtable

.EXAMPLE
Chart with unsorted data.
PS C:\> $cities = @{London=7556900; Berlin=8429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -chartTheme 1

.EXAMPLE
Chart with sorted data.
PS C:\> $cities = @{London=7556900; Berlin=8429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -chartTheme 1 -sort dsc

.EXAMPLE
Chart with percentages shown on the pie/doughnut charts.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type Doughnut -Show_percentage_pie

.EXAMPLE
Chart with percentages shown on the pie/doughnut charts. Fixing the overlapping labels on the chart.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -charttheme 5 -Show_percentage_pie -fix_label_alignment

.EXAMPLE
If the chart type is pie or doughnut, you can specify a threshold (percentage) that all data values below it, will be shown as one data item called (Others).
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -type Doughnut -CollectedThreshold 16

.EXAMPLE
Column chart with green columns.
PS C:\> $cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539;Paris=2188500}
PS C:\> Get-Corpchart-FullEdition -data $cities -filepath "c:\chart.png" -chart_color green


.Notes
Last Updated             : Nov 30, 2013
Version                  : 2.0 
Author                   : Ammar Hasayen (Twitter @ammarhasayen)
Email                    : me@ammarhasayen.com


.Link
http://ammarhasayen.com




#>

    [cmdletbinding( HelpUri = 'http://ammarhasayen.com/',
                    DefaultParameterSetName= "Parameter Set 1")]  


    Param(

        #region REQUIRED parameters

            # REQUIRED
            [Parameter(Position = 0,Mandatory = $true,HelpMessage = "Data to be presented as a chart. This can be hashtable or array of objects.") ]
            [ValidateNotNull()]
            [ValidateNotNullorEmpty()]
            [object]$data,  

            # REQUIRED
            [Parameter(Position = 1,Mandatory=$true,HelpMessage = "Enter file path to save the chart. Example 'c:\char.png'.") ]   
            [string]$filepath,
        
        #endregion REQUIRED parameters



        #region OPTIONAL parameters
        
            # Chart type

            # the difference between Parameter Set 1 and Parameter Set 2 is weather you specifically configure the chart type using -Type parameter,
            # or you use on of the chart themes using ChartTheme parameter. You cannot use both the -Type and -chartTheme parameters.

            [Parameter(Position = 2, Mandatory = $false,HelpMessage = "Enter chart type. Default is 'column'.",ParameterSetName ='Parameter Set 1') ] 
            [ValidateSet("Point", "FastPoint", "Bubble", "Line","Spline", "StepLine", "FastLine", "Bar","StackedBar", "StackedBar100", "Column","StackedColumn", "StackedColumn100", "Area","SplineArea","StackedArea", "StackedArea100","Pie", "Doughnut", "Stock", "Candlestick","Range","SplineRange", "RangeBar", "RangeColumn","Radar", "Polar", "ErrorBar", "BoxPlot", "Renko","ThreeLineBreak", "Kagi", "PointAndFigure", "Funnel","Pyramid")]  
            [string]$Type = "column",  

            [Parameter(Mandatory = $false, ParameterSetName ='Parameter Set 2',HelpMessage = "Instead of using the -Type parameter to specify chart type, use one of the available themes.") ] 
            [ValidateSet(1,2,3,4,5,6,7)]
            [int]$chartTheme = 1,

        
            # Chart Titles

            [Parameter(Position = 3,HelpMessage = "Enter the title of the chart.") ] 
            [string]$title_text = " ",


            [Parameter(Position = 4,HelpMessage = "Enter the X Axis title of the chart.") ]  
            [string]$chartarea_Xtitle = " ",

            [Parameter(Position = 5,HelpMessage = "Enter the Y Axis title of the chart.") ]    
            [string]$chartarea_Ytitle = " ",

        
            # Chart Axis Intervals           
        
            [Parameter(Position = 6,HelpMessage = "Enter X Axis interval. Default is 1.") ] 
            [int]$Xaxis_Interval = 1,

            [Parameter(Position = 7,HelpMessage = "Enter Y Axis interval.Usually you do not need to use this parameter.") ] 
            [int]$Yaxis_Interval,

             # Chart look and feel

            [Parameter(Position = 8, HelpMessage = "Enter chart column color. Only in case of 'column' or 'bar' chart types.") ] 
            [string]$chart_color = "MediumSlateBlue",

            [Parameter(Position = 9,HelpMessage = "Enter chart title color. Default is 'red'.") ] 
            [string]$title_color="red",        

            [Parameter(Mandatory = $false,ParameterSetName ='Parameter Set 1',HelpMessage = "Very advance option. Only applicable of you use the -Type parameter. Customize the chart by providing hashtable of properties. Look at the examples for more info.") ] 
            [hashtable]$customLook,


            # Chart extra customization 
       
            [Parameter(Mandatory = $false , HelpMessage = "Enter a threshold that all data values below it will be grouped as one item named 'Others'. This parameter takes an integer from 1 to 100.") ] 
            [ValidateRange(0,100)]
            [int]$CollectedThreshold,

            [Parameter(Mandatory = $false ,HelpMessage = "Sort the data option.") ] 
            [ValidateSet("asc","dsc")]
            [string]$sort,   


            [Parameter(Mandatory = $false ,HelpMessage = "Use this switch to determine if values are shown as labels in the chart, default is no.") ]  
            [switch]$IsvalueShownAsLabel,
    
     
            [Parameter(Mandatory = $false ,HelpMessage = "Use this switch to determine if the highest and lowest items should be highlighted.") ] 
            [switch]$showHighLow,

        
            [Parameter(Mandatory = $false ,HelpMessage = "Use this switch to determine if legend should be added to the chart.") ] 
            [switch]$showLegend,

       
            [Parameter(Mandatory = $false ,HelpMessage = "This parameter is required when the input data type is array of objects. This represents the name of the object properties to be used as X Axis data.") ] 
            [string]$obj_key,

       
            [Parameter(Mandatory = $false ,HelpMessage = "This parameter is required when the input data type is array of objects. This represents the name of the object properties to be used as Y Axis data.") ] 
            [string]$obj_value,

            [Parameter(Mandatory = $false ,HelpMessage = "Append the current data to the title.") ] 
            [switch]$append_date_title,

       
            [Parameter(Mandatory = $false ,HelpMessage = "Only applicable if the chart type is Pie or Doughnut. If the data labels in the chart are overlapping, use the switch to fix it.") ] 
            [switch]$fix_label_alignment,

       
            [Parameter(Mandatory = $false ,HelpMessage = "Only applicable if the chart type is Pie or Doughnut. This will show the data labels on the chart as percentages instead of actual data values.") ] 
            [switch]$show_percentage_pie
       
       #endregion
    
    )

    Begin {            

            # Function Get-Corpchart-FullEdition BEGIN Section

            Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"  

            Write-verbose -Message ($PSBoundParameters | out-string)


            #region local variables
            

                New-Variable -Name currentDate `
                             -Option ReadOnly `
                             -Value (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') `
                             -scope local 

                New-Variable -Name font_Style1 `
                             -Option ReadOnly `
                             -Value (new-object system.drawing.font("ARIAL",18,[system.drawing.fontstyle]::bold)) `
                             -scope private 

                New-Variable -Name font_style2 `
                             -Option ReadOnly `
                             -Value (new-object system.drawing.font("calibri",16,[system.drawing.fontstyle]::italic)) `
                             -scope private 

                # chart background color
                New-Variable -Name chartarea_backgroundcolor `
                             -Option ReadOnly `
                             -Value "white" `
                             -scope private

           

            
                # default chart dimension
                $propChartDimension  = @{ "width"           = 1500;
                                          "height"          = 800;
                                          "left"            = 80;
                                          "top"             = 100;
                                          "name"            = "chart";
                                          "BackColor"       = "white"
                              } 

                $ObjChartDimension = New-Object -TypeName psobject -Property $propChartDimension



                # hashtable for theme IDs
                $theme_charttype = @{ 1   = "column"  ;
                                      2   = "column"  ;
                                      3   = "bar"     ;
                                      4   = "Doughnut";
                                      5   = "Doughnut";
                                      6   = "pie"     ;
                                      7   = "Doughnut";
                                    }

                # hashtable to mark dimensions that will be scaled dynamically according to the number of input objects
                $dynamicdimension = @{"column"="width";
                                      "bar"   ="height"
                                     }
            #endregion local variables


            #region get class

                # loading the data visualization .net class
                [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

            #endregion get class


            #region internal functions

                Function Get-CorpCalculateDim {

                    # Adjust width (in case of charts with 'column' type
                    # or height (in case of charts with 'bar' type according to the number of items
                    # Criteria :For each 15 item, dimention should expand by 1000

                    param ($count)

                        [int]$v = ($count / 15)

                        # if input items are less than 15 items (which gives 0 when doing int division by 15)
                        if($v -eq 0) {$v=1}
                        # if input items are more than 15 items
                        else { $v=$v+1}

                        return ($v*1000)

                } #  Function Get-CorpCalculateDim



            #endregion internal functions
            
            
    } # Function Get-Corpchart-FullEdition BEGIN Section

    Process {             
            
          

            #region input validation
            
              # you should use the -obj_key and -obj_value if the input data is array of objects
                if (($data.gettype()).name -notlike "hashtable") {

                      if ( -not (   ($PSBoundParameters.ContainsKey("obj_key") ) -and (($PSBoundParameters.ContainsKey("obj_value")) ))) {

                         throw " Since your data is not a hashtable, then it shall be array of objects. In this case, use -obj_key and -obj_value parameter to inform the function about which properties to draw."

                      } # end if


                } # end if

            
                # do not use the -obj_key and -obj_value parameters if the input data is hashtable
                if (($data.gettype()).name -like "hashtable") {

                      if (  (   ($PSBoundParameters.ContainsKey("obj_key") ) -or (($PSBoundParameters.ContainsKey("obj_value")) ))) {

                         throw "Input data is hashtable. No need to specify -obj_key or -obj_value parameter"

                      } # end if


                } # end if   



            #endregion  input validation           
          

            #region create chart  
              $var = $ErrorActionPreference
              $ErrorActionPreference = "stop"
              try {
                 $chart  = new-object System.Windows.Forms.DataVisualization.Charting.Chart
              }catch {
                Write-warning -Message "This script  Requires both .NET 3.5 and Microsoft Chart Controls for Microsoft .NET Framework 3.5"
                Write-warning -Message "Use this link to download Chart Controls http://www.microsoft.com/en-us/download/details.aspx?id=14422"
                Exit
                Throw "This script  Requires both .NET 3.5 and Microsoft Chart Controls for Microsoft .NET Framework 3.5"
              }finally {
                $ErrorActionPreference = $var
              }  
              
            #endregion

            
            #region chart data

                [void]$chart.Series.Add("Data") 

                if (($data.gettype()).name -notlike "hashtable")  { # input data is array of objects

                    $array_keys   = @()
                    $array_values = @()

                    foreach ($object in $data) {

                        $array_keys += $object.$obj_key
                        $array_values += $object.$obj_value   

                    } # end foreach
            
                    $chart.Series["Data"].Points.DataBindXY($array_keys, $array_values)

                } # if (($data.gettype()).name -notlike "hashtable")


                else { # if input data is hashtable

                    $chart.Series["Data"].Points.DataBindXY($data.Keys, $data.Values)

                } # end else        
            
            #endregion chart data


            #region chart type

                # if parameter set 1, then the type is the input Type variable
                # if parameter set 2, then the input type is determined according to the theme ID entered
                switch ($psCmdlet.ParameterSetName) {

                   "Parameter Set 1"  {$chart_type   =  $Type}
                   "Parameter Set 2"  {$chart_type   =  $theme_charttype[$chartTheme]} 
            
                } # end switch

                $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$chart_type
            
            #endregion chart type


            #region chart look and size : setting default chart dimensions 
            
                $chart.width     = $ObjChartDimension.width
                $chart.Height    = $ObjChartDimension.height
                $chart.Left      = $ObjChartDimension.left
                $chart.top       = $ObjChartDimension.top
                $chart.Name      = $ObjChartDimension.name
                $chart.BackColor = $ObjChartDimension.BackColor

                # if the chart type is one that needs dynanmic dimensions according to the $dynamicdimension hashtable
                # then we need to pull the dimension to be dynamically calculated
                # example, if you are going to draw column chart type, then we will expand the width of the chart
                # according to the number of items in the input data to give some room.
                # while if you are going to draw a bar chart type, then we will expand the height accordingly.
                if ($dynamicdimension.ContainsKey($chart_type)) {

                    # the variable item represents which dimension (according to the chart type) to  be dynamically calculated.
                    # for example, in case of column chart type, #item will be the width dimension.
                    $item = $dynamicdimension[$chart_type]
                    # the function Get-CorpCalculateDim will return the value of that item by giving it the number of items in the data input.
                    $chart.$item =  Get-CorpCalculateDim ($data.count)

                } # if ($dynamicdimension.ContainsKey($chart_type))             

            #endregion chart look and size : setting default chart dimensions 


            #region chart label

                # if the $IsvalueShownAsLabel switch is specified, we will enable the label on the chart
                $chart.Series["Data"].IsvalueShownAsLabel = $IsvalueShownAsLabel

            #endregion chart label


            #region chart custom look

                # this is advance option where you specify extra attribute to the chart to alter its look.
                if ( $PSBoundParameters.ContainsKey("customLook") ) { 

                     $keys= $customLook.keys

                     foreach ($key in $keys) {

                         $value = $customLook[$key]

                         $chart.Series["Data"][$key] = $value

                     } #end foreach ($key in $keys) 
            
                } # end if ( $PSBoundParameters.ContainsKey("customLook") ) 

            #endregion  chart custom look 


            #region chart max min

                # there is an option where the highest and lowest values in the input data can be highlighted by different colors
                # if you specify the -showHighLow switch, the chart will do the highlighting

                if ( $PSBoundParameters.ContainsKey("showHighLow") ) {

                     #Find point with max value and change the colour of that value to red
                     $maxValuePoint = $Chart.Series["Data"].Points.FindMaxByValue() 
                     $maxValuePoint.Color = [System.Drawing.Color]::Red 
 
                     #Find point with min value and change the colour of that value to green
                     $minValuePoint = $Chart.Series["Data"].Points.FindMinByValue() 
                     $minValuePoint.Color = [System.Drawing.Color]::Green
                }

            #endregionchart max min


            #region Title

                # putting the title of the chart

                $title =New-Object System.Windows.Forms.DataVisualization.Charting.title
                $chart.titles.add($title)            
                $chart.titles[0].font         = $font_style1
                $chart.titles[0].forecolor    = $title_color
                $chart.Titles[0].Alignment    = "topLeft"

                if ($PSBoundParameters.ContainsKey("append_date_title") ) {

                    $chart.titles[0].text   = ($title_text + "`n " + $currentDate )


                }
                else {
                
                    $chart.titles[0].text   = $title_text

                }

            #endregion  Title


            #region legend

                # putting the legend of the chart if the -showlegend switch is used

                if ( $PSBoundParameters.ContainsKey("showlegend") ) {

                    $legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
                    $legend.BorderColor     = "Black"
                    $legend.Docking         = "Top"
                    $legend.Alignment       = "Center"
                    $legend.LegendStyle     = "Row"
                    $legend.MaximumAutoSize  = 100
                    $legend.BackColor       = [System.Drawing.Color]::Transparent  
                    $legend.shadowoffset= 1  
                    
                    $chart.Legends.Add($legend)

                } # if ( $PSBoundParameters.ContainsKey("showlegend") )


            #endregion legend


            #region chart area

                # chart area is where the X axis and Y axis titles and font style is to be configured.

                $chartarea                = new-object system.windows.forms.datavisualization.charting.chartarea
                $chartarea.backcolor      = $chartarea_backgroundcolor
                $ChartArea.AxisX.Title    = $chartarea_Xtitle
                $ChartArea.AxisX.TitleFont= $font_style2
                $chartArea.AxisY.Title    = $chartarea_Ytitle             
                $ChartArea.AxisY.TitleFont= $font_style2
                $ChartArea.AxisX.Interval = $XAxis_Interval 
            
                if ($PSBoundParameters.ContainsKey("YAxis_Interval") ) {
                    $ChartArea.AxisY.Interval = $YAxis_Interval           
                }

                $chart.ChartAreas.Add($chartarea)

            #endregion chart area
            

            #region chart themes 

            # instead of manually specifying the chart type, you can supply a chart theme ID by using the -chartTheme parameter
            # this will gives you out of the box customized settings for the chart type, look and feel.
            
            if ( $PSBoundParameters.ContainsKey("chartTheme") ) {

                switch ($chartTheme) {

            
                #region theme1

                1 {
                    # chart type will be column with emboss drawing style.

                    # setting chart type
                    $theme_name = $theme_charttype[1]
                    $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$theme_name
                    
                    # drawing style values "Cylinder, Emboss, LightToDark, Wedge, Default"                    
                    $chart.Series["Data"]["DrawingStyle"] = "Emboss"  

                    # the X axis and Y axis line type is set with a small arrow at the line end.It is up to you to enable this option.
                    # $chartarea.AxisX.ArrowStyle = "Triangle"
                    # $chartarea.AxisY.ArrowStyle = "Triangle"
                    
                } # end theme 1

                #endregion

                #region theme2

                2 {
                    # chart type will be column with emboss drawing style an 3D.
                    
                    # setting chart type
                    $theme_name = $theme_charttype[2]
                    $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$theme_name
 
                    # Drawing style values "Cylinder, Emboss, LightToDark, Wedge, Default"                    
                    $chart.Series["Data"]["DrawingStyle"] = "Emboss"
                    
                    #configuring 3D style.
                    $chartarea.Area3DStyle.Enable3D = $true
                    
                } # end theme 2

                #endregion

                #region theme3

                 3 {
                    # chart type will be bar with emboss drawing style.

                    # setting chart type
                    $theme_name = $theme_charttype[3]
                    $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$theme_name

                    # Drawing style values "Cylinder, Emboss, LightToDark, Wedge, Default"
                    $chart.Series["Data"]["DrawingStyle"] = "Emboss"
                    
                } # end theme 3

                #endregion

                #region theme4

                 4 { 
                    # Doughnut with SoftEdge look

                    # setting chart type
                    $theme_name = $theme_charttype[4]
                    $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$theme_name

                    # customizing the doughnut 
                    $chart.Series["Data"]["PieLabelStyle"]                       = "Outside" 
                    $chart.Series["Data"]["PieLineColor"]                        = "Black"                     
                    ($chart.Series["Data"].Points.FindMaxByValue())["Exploded"]  = $true                    
                    $chart.Series["Data"]["PieDrawingStyle"]                     = "SoftEdge"
                    $chart.Series["Data"]["DoughnutRadius"]                      = "60"
                    $chart.Series["Data"].Label = "#VALX (#VALY)"
                    $chart.Series["Data"].LegendText = "#VALX" 

                } # end theme 4

                #endregion
                
                #region theme5

                 5 { 
                    # Doughnut with concave look

                    # setting chart type
                    $theme_name = $theme_charttype[5]
                    $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$theme_name

                    # customizing the doughnut
                    $chart.Series["Data"]["PieLabelStyle"]                       = "Outside" 
                    $chart.Series["Data"]["PieLineColor"]                        = "Black" 
                    $chart.Series["Data"]["PieDrawingStyle"]                     = "Concave" 
                    ($chart.Series["Data"].Points.FindMaxByValue())["Exploded"]  = $true 
                    $chart.Series["Data"]["DoughnutRadius"]                      = "60"
                    $chart.Series["Data"].Label = "#VALX (#VALY)"
                    $chart.Series["Data"].LegendText = "#VALX"

                } # end theme 5

                #endregion
                
                #region theme6

                 6 { 
                    # Pie

                    # setting chart type
                    $theme_name = $theme_charttype[6]
                    $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$theme_name

                    # customizing the doughnut
                    $chart.Series["Data"]["PieLabelStyle"]                       = "Outside" 
                    $chart.Series["Data"]["PieLineColor"]                        = "Black" 
                    $chart.Series["Data"].Label = "#VALX (#VALY)"
                    $chart.Series["Data"].LegendText = "#VALX"
                    
                } # end theme 6

                #endregion

                #region theme7

                 7 { 
                    # Doughnut with 3D

                    # Chart type
                    $theme_name = $theme_charttype[7]
                    $chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$theme_name

                    # customizing the doughnut 
                    $chart.Series["Data"]["PieLabelStyle"]                       = "Outside"                     
                    ($chart.Series["Data"].Points.FindMaxByValue())["Exploded"]  = $true 
                    $chart.Series["Data"]["DoughnutRadius"]                      = "60"
                    $chartArea.Area3DStyle.Enable3D                              = $true
                    $chartArea.Area3DStyle.IsClustered                           = $true
                    $chartArea.Area3DStyle.Perspective =10
                    $chartArea.Area3DStyle.PointGapDepth =900
                    $chartArea.Area3DStyle.WallWidth =25
                    $chartArea.Area3DStyle.Rotation =65
                    $chartArea.Area3DStyle.Inclination=35
                    $chart.Series["Data"].Label = "#VALX (#VALY)"
                    $chart.Series["Data"].LegendText = "#VALX"
                    
                } # end theme 7

                #endregion

                } # end switch


            } # end if ( $PSBoundParameters.ContainsKey("chartTheme") )
            
            #endregion   chart themes

            
            #region more configurations. 
            
                #region Pie and Doughnuts configuration

                    if (($chart_type -like "pie") -or ($chart_type -like "Doughnut") ) {
                    # this applies only if the chart type is Pie or Doughnut.
                
                        #region CollectedThreshold settings
                
                        # sometimes, there is so much data to draw, you can specify a threshold (value between 1 and 100) 
                        # which represents a percentage of the input data value, that is when any data item value is below it
                        # the chart will group them under (Other) as one item with green color.
                        if ( $PSBoundParameters.ContainsKey("CollectedThreshold") ) {

                               $chart.Series["Data"]["CollectedThreshold"]           = $CollectedThreshold   
                               $chart.Series["Data"]["CollectedLabel"]               = "Other"
                               $chart.Series["Data"]["CollectedThresholdUsePercent"] = $true
                               $chart.Series["Data"]["CollectedLegendText"]          = "Other"
                               $chart.Series["Data"]["CollectedColor"]               = "green"

                        } # if ( $PSBoundParameters.ContainsKey("CollectedThreshold") )

                #endregion Pie and Doughnuts configuration

                #region fix alignment for labels

                # sometime the labels on the chart overlap above each other's making ugly look
                # the trick is make that chart as 3D with zero inclination
                # this can be done if you specify the -fix_label_alignment switch
                if ( $PSBoundParameters.ContainsKey("fix_label_alignment") ) {

                    $chartArea.Area3DStyle.Enable3D = $true

                    # if there is no inclination configured, that is if the chart is configured as 3D.
                    # this validation is important to prevent overwriting an already configured inclination for 3D charts.
                    if(-Not ($chartArea.Area3DStyle.Inclination)) { $chartArea.Area3DStyle.Inclination = 0 }
                

                } # if ( $PSBoundParameters.ContainsKey("fix_label_alignment") )
                
                #endregion

                #region show data as percentage

                # sometimes, it is better to show the data values as percentages instead of actual values.
                # this can be done by using the -show_percentage_pie.
                # this applies to both pie and doughnut chart types.
                if ( $PSBoundParameters.ContainsKey("show_percentage_pie") ) {
                                   
                    #we will set the label to VLAX which is the X axis value then the percent with two decimals of the value (Y axis)
                    $chart.Series["Data"].Label = "#VALX (#PERCENT{P2})"

                    # on the legend, we will put the X axis value (VLAX).
                    $chart.Series["Data"].LegendText = "#VALX"                    

                } # if ( $PSBoundParameters.ContainsKey("show_percentage_pie") )


                #endregion

            } # if (($chart_type -like "pie") -or ($chart_type -like "Doughnut") )

            #endregion

                #region Column and Bar configuration

                    if (($chart_type -like "column") -or ($chart_type -like "bar") ) {
                    # this applies only if the chart type is column or bar.
            
                         # the X axis and Y axis line colors are set to DarkBlue.
                         $chartarea.AxisX.LineColor =[System.Drawing.Color]::DarkBlue 
                         $chartarea.AxisY.LineColor =[System.Drawing.Color]::DarkBlue                 

                         # the title of the X axis and Y axis font color is set to DarkBlue.
                         $ChartArea.AxisX.TitleForeColor =[System.Drawing.Color]::DarkBlue
                         $ChartArea.AxisY.TitleForeColor =[System.Drawing.Color]::DarkBlue 
                 
                         # configuring the internal chart grid.

                         # enable customization of the grid
                         $chartarea.AxisX.IsInterlaced = $true 
                         # the grid line color
                         $chartarea.AxisX.InterlacedColor = [System.Drawing.Color]::AliceBlue 
                         # grid line type
                         $chartarea.AxisX.ScaleBreakStyle.BreakLineStyle = "Straight"
                         # grid area alternate color for both axises
                         $chartarea.AxisX.MajorGrid.LineColor =[System.Drawing.Color]::LightSteelBlue 
                         $chartarea.AxisY.MajorGrid.LineColor =[System.Drawing.Color]::LightSteelBlue 

                         # configuring the chart column internal color
                         $chart.Series["Data"].Color = $chart_color


                    } # if (($chart_type -like "column") -or ($chart_type -like "bar") )

                 #endregion Column and Bar configuration           

                #region Configuration that applies to all chart types

                     #region drawing a border around the whole chart

                         $chart.BorderlineWidth = 1
                         $chart.BorderColor = [System.Drawing.Color]::black
                         $chart.BorderDashStyle = "Solid" # values can be "Dash","DashDot","DashDotDot","Dot","NotSet","Solid"
                         $chart.BorderSkin.SkinStyle = "Emboss"

                     #endregion drawing a border around the whole chart

                #endregion Configuration that applies to all chart types

                #region data sorting

                     # showing the data sorted is a welcome thing. If you specify the -sort parameter, we will sort the data before drawing it.
             
                     if ($sort -like "asc") {
                        $Chart.Series["Data"].Sort([System.Windows.Forms.DataVisualization.Charting.PointSortOrder]::Ascending, "Y") 
                     }
              
                     elseif ($sort -like "dsc") {

                        $Chart.Series["Data"].Sort([System.Windows.Forms.DataVisualization.Charting.PointSortOrder]::Descending, "Y") 
                     }

                #endregion data sorting

            #endregion more configurations.
             


    } # Function Get-Corpchart-FullEdition PROCESS Section


    End {
            
            # Function Get-Corpchart-FullEdition END Section
            
             Write-Verbose -Message "Function Get-Corpchart-FullEdition Ends"

             #region save chart

              $var = $ErrorActionPreference
              $ErrorActionPreference = "stop"
              try {
                  $chart.SaveImage($filepath, "PNG")
              }catch {
                Write-warning -Message "Cannot save chart on $filepath !! OPS... FilePath parameter should be something like c:\chart.PNG"                
                Exit
                Throw "Cannot save chart on $filepath !! OPS... FilePath parameter should be something like c:\chart.PNG"
              }finally {
                $ErrorActionPreference = $var
              }  

             $chart.SaveImage($filepath, "PNG")

             #endregion

         

    } # Function Get-Corpchart-FullEdition END Section


} # Function Get-Corpchart-FullEdition

