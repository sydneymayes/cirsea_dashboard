server <- function(input, output) {
  
  
    # FILTER IUU DATA
    filtered_iuu_data <- reactive({
      # Exit early if input not yet selected
      if(is.null(input$iuu_type_input) || is.null(input$range_input)) {
        return(data.frame())
      }
      
      # Get the selected iuu_type and range from user input
      user_iuu_type <- input$iuu_type_input
      user_area <- input$range_input
      # user_area <- "Local" for example
      
      user_cost <- input$cost_input
      # user_cost <- "$" for example
      
      user_data <- input$data_type_input
      # user_data <- "Location"
      
      
      # Find the lower and upper limits for the selected range from bin_ranges_df
      limits <- bin_ranges_df %>%
        filter(Bin %in% user_area) %>%
        summarise(Lower = first(Lower), Upper = first(Upper))
      
      lower_limit <- limits$Lower
      upper_limit <- limits$Upper
      
      
      # DOING A SIMILAR THING FOR COSTS -------------
      cost_ranges <- cost_ranges_df %>%
        filter(Bin %in% user_cost) %>%
        summarise(Lower = first(Lower), Upper = first(Upper))

      lower_limit_cost <- cost_ranges$Lower
      upper_limit_cost <- cost_ranges$Upper

      numeric_costs <- unique(c(cost_ranges$Lower, cost_ranges$Upper))
      
      ##### Previous code for when costs were multiplied to increase magnitude
      # cost_mapping <- setNames(c(1, 2, 3), c("$", "$$", "$$$"))
      # numeric_user_costs <- cost_mapping[user_cost]
      # 
      # numeric_costs <- sensor_platform_combinations_cost_df %>%
      #   filter(total_cost == numeric_user_costs)

      
      # Now trying for DATA INPUT ----------
      
      
      # Filter merged_index_df for the selected iuu_type
      
      selected_columns <- c("sensor_platform", input$iuu_type_input, "total_cost", "total_cost_bins", "data_type")
      selected_iuu_type_df <- merged_index_df %>%
        select(all_of(selected_columns))
      
      
      # Initialize an empty list to store indices that meet the criteria
      
      # relevant_row_indices <- list()
      
      for (col_name in names(selected_iuu_type_df)[2:(length(selected_iuu_type_df)-3)]) {
        column_values <- selected_iuu_type_df[[col_name]] # for each column name, determines all the column values
        
        # Identify row indices where values are within the specified range
        
        within_range_indices <- which(column_values >= lower_limit & column_values <= upper_limit) 
        
      }
      
      # Filter the dataframe to include only the rows with relevant values
      
      # This is working below
      
      
      if (!is.null(input$range_input)) {
        data <- selected_iuu_type_df[within_range_indices, ]
      }
      if (!is.null(input$cost_input)) {
        data <- data[data$total_cost %in% numeric_costs, ]
      }
      if (!is.null(input$data_type_input)) {
        data <- data[grepl(user_data, data$data_type), ]
      }
    
      data
      
    
    })
    
    # build table
    
    ####### Output the filtered data table
    output$iuu_table_output <- renderDataTable({
      filtered_iuu_data() %>%
        select(sensor_platform, data_type) %>%
        rename("Evidence Provided" = data_type,
               "Sensor + Platform" = sensor_platform)

    }, options = list(pageLength = 10))

    
    ####### Output conditional text
    
    output$text_output <- renderUI({
      
      long_range_camera <- any(grepl("long_range_camera", filtered_iuu_data()$sensor_platform))
      hydroacoustics <- any(grepl("hydroacoustics", filtered_iuu_data()$sensor_platform))
      # need to add highly_sensitive_hydroacoustics
      # need to add mid_range_camera
      # need to change aerial_drone to large_aerial_drone and small_aerial_drone
      # need to incorporate 'onboard' into the matrix as a platform
      # are we separating out usv into different sizes...?
      # need to add cell_phone_camera
      # need to add electronic_monitoring_system  
      aerial_drone <- any(grepl("aerial_drone", filtered_iuu_data()$sensor_platform))
      onboard_observer <- any(grepl("onboard_observer", filtered_iuu_data()$sensor_platform))
      radar <- any(grepl("radar", filtered_iuu_data()$sensor_platform))
      radio_frequency <- any(grepl("radio_frequency", filtered_iuu_data()$sensor_platform))
      manned_aircraft <- any(grepl("manned_aircraft", filtered_iuu_data()$sensor_platform))
      manned_vessel <- any(grepl("manned_vessel", filtered_iuu_data()$sensor_platform))
      on_shore_command_center <- any(grepl("on_shore_command_center", filtered_iuu_data()$sensor_platform))
      smart_buoy <- any(grepl("smart_buoy", filtered_iuu_data()$sensor_platform))
      usv <- any(grepl("usv", filtered_iuu_data()$sensor_platform))
      
      
      ui_elements <- list()
      
      # If 'long_range_camera' is found, add its content to the list
      if (long_range_camera) {
        #print("Long range camera found")
        long_range_camera_text <- "text/long_range_camera_tool.md"
        if(file.exists(long_range_camera_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(long_range_camera_text)))
          
        }
      }
      
      # # # If 'aerial_drone' is found, add its content to the list
      if (aerial_drone) {
        aerial_drone_text <- "text/aerial_drone_tool.md"
        if(file.exists(aerial_drone_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(aerial_drone_text)))
        }
      }
      
      
      # If 'hydroacoustics' is found, add its content to the list
      if (hydroacoustics) {
        hydroacoustics_text <- "text/hydroacoustics_tool.md"
        if(file.exists(hydroacoustics_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(hydroacoustics_text)))
        }
      }
      
      # If 'onboard observer' is found, add its content to the list
      if (onboard_observer) {
        onboard_observer_text <- "text/onboard_observer_tool.md"
        if(file.exists(onboard_observer_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(onboard_observer_text)))
        }
      }
      
      # If 'radar' is found, add its content to the list
      if (radar) {
        radar_text <- "text/radar_tool.md"
        if(file.exists(radar_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(radar_text)))
        }
      }
      
      if (radio_frequency) {
        radio_frequency_text <- "text/radio_frequency_tool.md"
        if(file.exists(radio_frequency_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(radio_frequency_text)))
        }
      }
      
      if (manned_aircraft) {
        manned_aircraft_text <- "text/manned_aircraft_tool.md"
        if(file.exists(manned_aircraft_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(manned_aircraft_text)))
        }
      }
      
      if (manned_vessel) {
        manned_vessel_text <- "text/manned_vessel_tool.md"
        if(file.exists(manned_vessel_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(manned_vessel_text)))
        }
      }
      
      if (on_shore_command_center) {
        on_shore_command_center_text <- "text/on_shore_command_center_tool.md"
        if(file.exists(on_shore_command_center_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(on_shore_command_center_text)))
        }
      }
      
      if (smart_buoy) {
        smart_buoy_text <- "text/smart_buoy_tool.md"
        if(file.exists(smart_buoy_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(smart_buoy_text)))
        }
      }
      
      if (usv) {
        usv_text <- "text/usv_tool.md"
        if(file.exists(usv_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(usv_text)))
        }
      }
      
      
      
      #### Finally done with all conditions and now returning them----------------
      
      # Return all UI elements if any, otherwise return nothing (NULL)
      if (length(ui_elements) > 0) {
        do.call(tagList, ui_elements)
      } else {
        return(NULL)
      }
      
      
    }) # END renderUI
    
    
    
    #### TESTING SATELLITE FILTER
    
    filtered_sat_data <- reactive({
      # Exit early if input not yet selected
      # if(is.null(input$iuu_type_input) || is.null(input$range_input)) {
      #   return(data.frame())
      # }

      user_iuu_type <- input$iuu_type_input

      user_sat_cost <- input$sat_cost_input

      user_sat_delivery <- input$sat_delivery_input
      
      
    
      selected_columns_sat <- c("satellites", "granularity_index", "cost", "delivery")
      selected_sat_df <- satellites %>%
        select(all_of(selected_columns_sat))
      
      # iuu_type_index %>% 
      #   filter(iuu_type == user_iuu_type) %>% 
      #   select(granularity_index)
      
      for (col_name in names(selected_sat_df)[3]) {
        column_values <- selected_sat_df[[col_name]] # for each column name, determines all the column values
        
        within_range_indices <- which(column_values == 1) # not free
        
      }
      
      
      for (col_name in names(selected_sat_df)[4]) {
        column_values <- selected_sat_df[[col_name]] # for each column name, determines all the column values
        
        within_range_indices_2 <- which(column_values == 1) # near real time delivery
        
      }
      
      # Filter the dataframe to include only the rows with relevant values

      
      # is not null NOT WORKING
      if (!is.null(input$sat_cost_input)) {
        data <- selected_sat_df[within_range_indices, ]
        #data <- selected_sat_df[selected_sat_df$cost == 1, ]
      }
      if (!is.null(input$sat_delivery_input)) {
        data <- data[within_range_indices_2, ]
      }
    
      data

    })
    
    #### Test satellite table filter
    
    output$sat_table_output <- renderDataTable({
      filtered_sat_data() 
    }, options = list(pageLength = 10))
    
    
  
    output$satellite_output <- renderUI({
      
      Maxar <- any(grepl("Gear-related offense", input$iuu_type_input))
      
      
      
      ui_elements_2 <- list()
      
      # If       is found, add its content to the list
      if (Maxar) {
        #print("Long range camera found")
        maxar_text <- "text/maxar_tool.md"
        if(file.exists(maxar_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(maxar_text)))
          
        }
      }
      
     
      
      #### Finally done with all conditions and now returning them----------------
      
      # Return all UI elements if any, otherwise return nothing (NULL)
      if (length(ui_elements_2) > 0) {
        do.call(tagList, ui_elements_2)
      } else {
        return(NULL)
      }
      
      
    }) # END renderUI
    

 
    ### IUU TYPE TAB --------------------------------------
 
    
    # Dark Vessels
    observeEvent(input$'Dark Vessels (not broadcasting location via VMS/AIS)', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/dark_vessels.md")
      })

    })
    
    
    
    # Fishing above quota
    observeEvent(input$`Fishing above quota`, {
      output$iuu_text <- renderUI({
        includeMarkdown("text/fishing_quota.md")
      })
      
    })
    
    # Fishing in a prohibited zone
    observeEvent(input$'Fishing in a prohibited zone', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/fishing_prohibited_zone.md")
      })
    })
    
    # Fishing out of season
    observeEvent(input$'Fishing out of season', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/fishing_season.md")
      })
    })
    
    # Fishing without license
    observeEvent(input$'Fishing without license', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/fishing_no_license.md")
      })
    })
    
    # Gear-related Offense
    observeEvent(input$'Gear-related offense', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/gear_offense.md")
      })
    })
    
    # Transhipments
    observeEvent(input$Transhipments, {
      output$iuu_text <- renderUI({
        includeMarkdown("text/transhipments.md")
      })
    })
    
    # Underreporting of fishing catch
    observeEvent(input$'Underreporting of fishing catch', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/underreporting_catch.md")
      })
    })
    
    # Underreporting of fishing effort
    observeEvent(input$'Underreporting of fishing effort', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/underreporting_effort.md")
      })
    })
    
    # Vessel with false flag
    observeEvent(input$'Vessel with false flag', {
      output$iuu_text <- renderUI({
        includeMarkdown("text/false_flag.md")
      })
    })
    
    


    
    
    
    ### Monitioring Methods TAB --------------------------------------
    
    ### Sensors -------------
    
    # Hydroacoustics
    observeEvent(input$hydroacoustics, {
      output$sensor_text <- renderUI({
        includeMarkdown("text/hydroacoustics.md")
      })
    })
    
    # Long Range Camera
    observeEvent(input$long_range_camera, {
      output$sensor_text <- renderUI({
        includeMarkdown("text/long_range_camera.md")
      })
    })
    
    # Onboard Observer
    observeEvent(input$onboard_observer, {
      output$sensor_text <- renderUI({
        includeMarkdown("text/onboard_observer.md")
      })
    })
    
    # Radar
    observeEvent(input$radar, {
      output$sensor_text <- renderUI({
        includeMarkdown("text/radar.md")
      })
    })
    
    
    # Radio Frequency
    observeEvent(input$radio_frequency, {
      output$sensor_text <- renderUI({
        includeMarkdown("text/radio_frequency.md")
      })
    })
    
    ## Platforms ---------
    
    # Aerial drone
    observeEvent(input$aerial_drone, {
      output$platform_text <- renderUI({
        includeMarkdown("text/aerial_drone.md")
      })
    })
    
    # Manned Aircraft
    observeEvent(input$manned_aircraft, {
      output$platform_text <- renderUI({
        includeMarkdown("text/manned_aircraft.md")
      })
    })
    
    # Manned Vessel
    observeEvent(input$manned_vessel, {
      output$platform_text <- renderUI({
        includeMarkdown("text/manned_vessel.md")
      })
    })
    
    # Onshore Command Center
    observeEvent(input$on_shore_command_center, {
      output$platform_text <- renderUI({
        includeMarkdown("text/on_shore_command_center.md")
      })
    })
    
    # Smart Buoy
    observeEvent(input$smart_buoy, {
      output$platform_text <- renderUI({
        includeMarkdown("text/smart_buoy.md")
      })
    })
    
    # USV
    observeEvent(input$usv, {
      output$platform_text <- renderUI({
        includeMarkdown("text/usv.md")
      })
    })
    
     
  
} #END SERVER