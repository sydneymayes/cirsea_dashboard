### UI PAGE

#........................dashboardHeader.........................
header <- dashboardHeader(
  
  
  # title ---
  title = "CIRSEA Group Project",
  titleWidth = 250
  
  
)

#........................dashboardSidebar........................
sidebar <- dashboardSidebar(
  
  # sidebar ---
  sidebarMenu(
    
    menuItem(text = "About", tabName = "about", icon = icon("star")), #tabName is our id
    menuItem(text = "IUU Tool", tabName = "tool", icon = icon("gear")),
    menuItem(text = "IUU Types", tabName = "iuu_types", icon = icon("fish")),
    menuItem(text = "Monitoring Strategies", tabName = "monitoring_strategies", icon = icon("magnifying-glass")),
    menuItem(text = "Additional Resources", tabName = "resources", icon = icon("book")),
    menuItem(text = "Methodology", tabName = "methodology", icon = icon("asterisk"))
    
  ) # END sidebarMenu
  
  
)

#..........................dashboardBody.........................
body <- dashboardBody(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  ),
  
  # set theme later
  # fresh::use_theme("something.css"),
  
  # tabItems ----
  tabItems(
    
    tabItem(tabName = "about",
            
            
            column(width = 12,
                   
                   # background info box ---
                   box(width = NULL,
                       
                       title = tagList(icon("fish"),
                                      strong("About The Project")),
                       includeMarkdown("text/about.md"),
                       tags$img(src = "1.png",
                                alt = "Logo image",
                                style = "max-width: 100%;") # often will just need to look up how to write the css
                       
                       
                   ) #END background box # takes on width of the column when set to null
                   
            ), # END column
            
          
            
            
    ), # END about tabItem
    
    # tool tabItem
    tabItem(tabName = "tool",
            
            # fluidRow ---
            fluidRow(
              
              # input box ---
              box(width = 4,
                  
                  title = tags$strong("IUU type and monitoring criteria:"),
                  
                  # IUU Type pickerinput ----
                  pickerInput(inputId = 'iuu_type_input',
                              label = 'Step 1: Select IUU type:',
                              choices = unique(iuu_type),
                              selected = unique(iuu_type)[1],
                              options = pickerOptions(actionsBox = TRUE),
                              multiple = FALSE),
                  
                  # section checkboxGroupButtons ----
                  radioGroupButtons(inputId = 'range_input',
                                    label = 'Step 2: Select your monitoring range:',
                                    choices = c("Local", "Regional", "High Seas"),
                                    selected = NULL,
                                    individual = TRUE, justified = TRUE, size = 'sm',
                                    checkIcon = list(yes = icon("check"))
                                    
                  ),
                  
                  # section checkboxGroupButtons
                  checkboxGroupButtons(inputId = 'cost_input',
                                       label = 'Filter by cost preference(s):',
                                       choices = c("$", "$$", "$$$"),
                                       selected = NULL,
                                       individual = FALSE, justified = TRUE, size = 'sm',
                                       checkIcon = list(yes = icon("check"))
                                       
                  ),
                  
                  # section checkboxGroupInput
                  checkboxGroupInput(inputId = "data_type_input",
                                     label = 'Filter by data interest(s):',
                                     choices = c("Eye-witness", "Image", "Location", "Video"),
                                     selected = NULL),
                  
                  
                  # div for satellite widgets
                  div(
                    h5("Satellite Specifications:", style = "margin-top: 20px; font-weight: bold;"),
                    
                    # Free or not
                    materialSwitch(
                      inputId = "sat_cost_input",
                      label = "Free Data", 
                      value = FALSE,
                      status = "primary"
                    ),
                    
                    materialSwitch(
                      inputId = "sat_delivery_input",
                      label = "Near Real-time Delivery", 
                      value = FALSE,
                      status = "success"
                    )
                  )
                  
                  
                  
                  
              ), #end first input box
              
              # Output box for temporary MS -- 
              ### DON'T DELETE THIS CODE BECAUSE IT IS HELPFUL TO VISUALIZE TABLE TO DEBUG
              
              # box(width = 8,
              # 
              #     title = strong("Recommended Monitoring Strategies"),
              # 
              #     # data table output ---
              #     dataTableOutput(outputId = "iuu_table_output") %>%
              #       withSpinner(color = "skyblue", type = 1),
              # 
              #     # div for satellites
              #     div(
              # 
              #     h4("Satellite Data Table", style = "margin-top: 30px; font-weight: bold;"),
              #     # data table output for satellites ---
              #     dataTableOutput(outputId = "sat_table_output") %>%
              #       withSpinner(color = "skyblue", type = 1),
              #     # if there is no sat data
              #     textOutput("no_data_message")
              #     ) # end div
              # 
              # 
              #        ), # END output box
              
              # descriptions box
              box(width = 8,
                  title = strong("Possible Monitoring Strategies"),
                  
                  div(
                    h4("Sensor and Platform Pairings:", style = "margin-top: 10px; margin-bottom: 20px; font-weight: bold;"),
                    uiOutput(outputId = "sensor_platform_output")
                  ),
                  
                  
                  # div for satellite widgets
                  div(
                    h4("Satellite Options:", style = "margin-top: 30px; margin-bottom:20px; font-weight: bold;"),
                    uiOutput(outputId = "satellite_output")
                  )
                  
              ), # end descriptions box
              
              
              
            ), # End fluidRow
            
            
            # # fluidRow 2 ---
            # fluidRow(
            #   
            #  
            #   ), # END second fluid row
            
            
    ), # END tool tabItem
    
    
    # IUU Types tab item
    tabItem(tabName = "iuu_types",
            
            # how to use
            fluidRow(
              column(width = 5,
                     #includeMarkdown("text/click_iuu.md")
                     div("IUU Fishing Events", style = "font-weight: bold; font-size: 20px; text-align:center;"),
                     div("Click to learn more.", style = "margin-bottom: 10px; padding:50x; font-size: 14px; text-align:center;")
        
              )),
            
            # IUU type text fluidRow ----
            fluidRow(
              useShinyjs(),  # Initialize shinyjs
              # # Testing out using tags to create a button with HTML content, including a line break
              # tags$button(id = "Vessel with false flag",
              #             style = "padding: 100px; font-size: 18px;",
              #             type = "button",
              #             class = "btn btn-default action-button",
              #             icon("flag"), "Vessel with", br(), "false flag"),
              # tags$button(id = "Underreporting of fishing effort",
              #             style = "padding: 100px; font-size: 18px;",
              #             type = "button",
              #             class = "btn btn-default action-button",
              #             icon("dumbbell"), "Underreporting of", br(), "fishing effort"),
              # 
              
              
              
              # Make a box for the IUU type buttons
              box(width = 5, style = "display: flex; flex-wrap: wrap; justify-content: center;",
                  # Define buttons for IUU types dynamically or statically here
                  actionButton("Fishing out of season", 
                               HTML(paste(icon("earth-americas"), 
                                          "<br>Fishing out of season")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Fishing in a prohibited zone", 
                               HTML(paste(icon("ban"), 
                                          "<br>Fishing in a prohibited zone")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Fishing above quota",
                               HTML(paste(icon("weight-scale"), 
                                          "<br>Fishing above quota")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Underreporting of fishing catch", 
                               HTML(paste(icon("fish"),
                                          "<br>Underreporting of fishing catch")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Underreporting of fishing effort", 
                               HTML(paste(icon("dumbbell"),
                                          "<br>Underreporting of fishing effort")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Prohibited Species", 
                               HTML(paste(icon("fish-fins"),
                                          '<br>Fishing for prohibited species')), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Bycatch", 
                               HTML(paste(icon("shrimp"),
                                          '<br>Illegal bycatch and discard')), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Gear-related offense", 
                               HTML(paste(icon("gear"), 
                                          "<br>Gear-related offense")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Fishing without license", 
                               HTML(paste(icon("id-card"), 
                                          "<br>Fishing without license")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Transhipments", 
                               HTML(paste(icon("ship"),
                                          "<br>Illegal Transhipments")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Dark Vessels (not broadcasting location via VMS/AIS)", 
                               HTML(paste(icon("moon"),
                                          "<br>Dark Vessels")), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Vessel with false flag", 
                               HTML(paste(icon("flag"),
                                          '<br>Vessel with false flag')), 
                               style='width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Reporting", 
                               HTML(paste(icon("book"),
                                          '<br>Noncompliance with reporting requirements')), 
                               style='width:400px; height:100px; font-size:120%; white-space:normal;')
                  # Add more buttons as needed
                  
              ), # end box for iuu type buttons
              
              # Make a box for the IUU Type Text
              box(width = 7,
                  uiOutput("picture_iuu"), 
                  uiOutput("iuu_text") # Placeholder for displaying text based on the selected IUU type
                  # tags$img(src = "IUU_1.jpeg",
                  #          alt = "boats",
                  #          style = "max-width: 100%;") 
              ) # End box for iuu type text
              
            ) # End fluid row
    ), # end IUU Types tab item
    
    
    # Monitoring Strategies tab item
    tabItem(tabName = "monitoring_strategies",
            # Sensors and how to use
            # Add new boxes in this section to structure like IUU types
            fluidRow(
              column(width = 5,
                     div("Sensors", style = "font-weight: bold; font-size: 20px; text-align:center;"),
                     div("Click to learn more.", style = "margin-bottom: 10px; padding:50x; font-size: 14px; text-align:center;"),
                     
              )),
            
            
            # Sensors fluidRow ----
            fluidRow(
              
              box(width = 5,style = "display: flex; flex-wrap: wrap; justify-content: center;",
                  # Define buttons for sensors
                  actionButton("AIS/VMS", 
                               HTML(paste(icon("location-crosshairs"),
                                          "<br>AIS and VMS")),
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("long_range_camera", 
                               HTML(paste(icon("camera"),
                                          "<br>Cameras")), 
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Electronic Monitoring Systems", 
                               HTML(paste(icon("video"),
                                          "<br>Electronic Monitoring Systems")),
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("Satellites", 
                               HTML(paste(icon("satellite"),
                                          "<br>Satellites")),
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("hydroacoustics", 
                               HTML(paste(icon("ear-listen"),
                                          "<br>Hydroacoustics")), 
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  
                  actionButton("radio_frequency", 
                               HTML(paste(icon("radio"),
                                          "<br>Radio Frequency")),
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("onboard_observer", 
                               HTML(paste(icon("glasses"),
                                          "<br>Onboard Observers")), 
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  actionButton("radar",
                               HTML(paste(icon("satellite-dish"),
                                          "<br>Radar")), 
                               style = 'width:200px; height:100px; font-size:120%; white-space:normal;'),
                  
                  # Add more buttons as needed
              ),
              

              box(width = 7,
                  uiOutput("picture_sensor"), 
                  uiOutput("sensor_text")) # Placeholder for displaying text based on the selected IUU type
        
                  ), # END Sensors  fluidRows
            
           
            
            
            # Platforms and how to use
            fluidRow(
              column(width = 5, 
                     div("Platforms", style = "font-weight: bold; font-size: 20px; text-align:center;"),
                     div("Click to learn more.", style = "margin-bottom: 10px; padding:50x; font-size: 14px; text-align:center;"),
              )),
            
            
            # Platforms fluidRow ----
            fluidRow(
              
              box(width = 5, style = "display: flex; flex-wrap: wrap; justify-content: center;",
                  # Define buttons for platforms
                  actionButton("aerial_drone", 
                               HTML(paste(icon("helicopter"),
                                          "<br>UAV<br>")), 
                               style = 'width:200px; height:100px; font-size:120%; white-space: normal;'),
                  actionButton("usv",
                               HTML(paste(icon("water"),
                                          "<br>USV")), 
                               style = 'width:200px; height:100px; font-size:120%'),
                  actionButton("manned_aircraft", 
                               HTML(paste(icon("plane"), 
                                          "<br>Manned Aircraft")), 
                               style = 'width:200px; height:100px; font-size:120%'),
                  actionButton("manned_vessel", 
                               HTML(paste(icon("ship"),
                                          "<br>Manned Vessel")), 
                               style = 'width:200px; height:100px; font-size:120%'),
                  actionButton("smart_buoy", 
                               HTML(paste(icon("code-commit"),
                                          "<br>Smart Buoy")), 
                               style = 'width:200px; height:100px; font-size:120%'),
                  actionButton("on_shore_command_center", 
                               HTML(paste(icon("computer"),
                                          "<br>Onshore Command Center")), 
                               style = 'width:200px; height:100px; font-size:120%; white-space: normal;'),
                  
                  # Add more buttons as needed
              ),
              
              
              
              box(width = 7, 
                  uiOutput("picture_platform"),
                  uiOutput("platform_text")) # Placeholder for displaying text based on the selected IUU type
            ) # END Platforms fluidRows
            
            
            
    ),# End Monitoring Strategies tab item
    
    
    
    # Additional Resources tab item
    tabItem(tabName = "resources",
            
    ), # END RESOURCES TAB ITEM
    
    
    # Methodology tab item
    tabItem(tabName = "methodology",
            
            
            column(width = 12,
                   
                   # background info box ---
                   box(width = NULL,
                       
                       title = tagList(icon("fish"),
                                       strong("Methodology")),
                       includeMarkdown("text/methodology.md") # often will just need to look up how to write the css
                       
                       
                   ) #END background box # takes on width of the column when set to null
                   
            ), # END column
            
    ) # END METHODOLOGY TAB ITEM
    
    
  ) #END tabItems
  
)



#..................combine all in dashboardPage..................
dashboardPage(header, sidebar, body)