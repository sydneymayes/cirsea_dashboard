server <- function(input, output) {
  
  
    # FILTER IUU DATA
    filtered_iuu_data <- reactive({
      # Exit early if input not yet selected
      if(is.null(input$iuu_type_input) || is.null(input$range_input)) {
        return(data.frame())
      }
      
      # Get the selected iuu_type and range from user input
      # Note, I did this just to test the logic at first
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
      # Note, there is a simpler way to do this, but I just modified the old code we had for speed
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

      
      # Filter merged_index_df for the selected iuu_type
      
      # selecting relevant columns of our merged_index_df, including the user's iuu type choice
      selected_columns <- c("sensor_platform", input$iuu_type_input, "total_cost", "total_cost_bins", "data_type")
      selected_iuu_type_df <- merged_index_df %>%
        select(all_of(selected_columns))
      
      # determining the values in the columns so that we can filter ranges
      for (col_name in names(selected_iuu_type_df)[2:(length(selected_iuu_type_df)-3)]) {
        column_values <- selected_iuu_type_df[[col_name]] # for each column name, determines all the column values
        
      # determining row indices where values are within the specified range
        within_range_indices <- which(column_values >= lower_limit & column_values <= upper_limit) 
      }
      
      # Filter the dataframe to include only the rows with relevant values
      
      # filtering by range, cost, and data type
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
    # note that we won't show the table in our final version,
    # but having it appear is very helpful for making sure things are filtering logically
    
    ####### Output the filtered data table
    output$iuu_table_output <- renderDataTable({
      filtered_iuu_data() %>%
        select(sensor_platform, data_type) %>%
        rename("Evidence Provided" = data_type,
               "Sensor + Platform" = sensor_platform)

    }, options = list(pageLength = 10))

    
    ####### Output conditional text
    # Can probably make this more efficient through a function?
    
    # these are the options sensor and platform options (make sure all have been added)
    output$sensor_platform_output <- renderUI({
      
      # long_range_camera <- any(grepl("long_range_camera", filtered_iuu_data()$sensor_platform))
      # hydroacoustics <- any(grepl("hydroacoustics", filtered_iuu_data()$sensor_platform))
      # # need to add highly_sensitive_hydroacoustics
      # # need to add mid_range_camera
      # # need to change aerial_drone to large_aerial_drone and small_aerial_drone
      # # need to incorporate 'onboard' into the matrix as a platform
      # # are we separating out usv into different sizes...?
      # # need to add cell_phone_camera
      # # need to add electronic_monitoring_system  
      # aerial_drone <- any(grepl("aerial_drone", filtered_iuu_data()$sensor_platform))
      # onboard_observer <- any(grepl("onboard_observer", filtered_iuu_data()$sensor_platform))
      # radar <- any(grepl("radar", filtered_iuu_data()$sensor_platform))
      # radio_frequency <- any(grepl("radio_frequency", filtered_iuu_data()$sensor_platform))
      # manned_aircraft <- any(grepl("manned_aircraft", filtered_iuu_data()$sensor_platform))
      # manned_vessel <- any(grepl("manned_vessel", filtered_iuu_data()$sensor_platform))
      # on_shore_command_center <- any(grepl("on_shore_command_center", filtered_iuu_data()$sensor_platform))
      # smart_buoy <- any(grepl("smart_buoy", filtered_iuu_data()$sensor_platform))
      # usv <- any(grepl("usv", filtered_iuu_data()$sensor_platform))
      
      # if no pairings
      no_pairings <- (nrow(filtered_iuu_data()) == 0)
      
      #### PAIRINGS (instead of individual)
      
      long_range_camera_by_small_usv <- any(grepl("long_range_camera by small usv", filtered_iuu_data()$sensor_platform))
      long_range_camera_by_large_usv <- any(grepl("long_range_camera by large usv", filtered_iuu_data()$sensor_platform))
      long_range_camera_by_large_aerial_drone <- any(grepl("long_range_camera by large_aerial_drone", filtered_iuu_data()$sensor_platform))
      long_range_camera_by_manned_vessel <- any(grepl(any(grepl("long_range_camera by large_aerial_drone", filtered_iuu_data()$sensor_platform)), filtered_iuu_data()$sensor_platform))
      long_range_camera_by_manned_aircraft <- any(grepl(any(grepl("long_range_camera by manned_aircraft", filtered_iuu_data()$sensor_platform)), filtered_iuu_data()$sensor_platform))
      long_range_camera_by_on_shore_command_center <- any(grepl("long_range_camera by on_shore_command_center", filtered_iuu_data()$sensor_platform))

      #
      mid_range_camera_by_small_aerial_drone <- any(grepl("mid_range_camera by small_aerial_drone", filtered_iuu_data()$sensor_platform))
      mid_range_camera_by_manned_vessel <- any(grepl("mid_range_camera by manned_vessel", filtered_iuu_data()$sensor_platform))
      mid_range_camera_by_on_shore_command_center <- any(grepl("mid_range_camera by on_shore_command_center", filtered_iuu_data()$sensor_platform))
      
      
      cell_phone_camera_by_onboard <- any(grepl("cell_phone_camera by onboard", filtered_iuu_data()$sensor_platform))

      electronic_monitoring_system_by_onboard <- any(grepl("electronic_monitoring_system by onboard", filtered_iuu_data()$sensor_platform))

      radio_frequency_by_small_usv <- any(grepl("radio_frequency by small usv", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_large_usv <- any(grepl("radio_frequency by large usv", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_small_aerial_drone <- any(grepl("radio_frequency by small_aerial_drone", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_large_aerial_drone <- any(grepl("radio_frequency by large_aerial_drone", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_smart_buoy <- any(grepl("radio_frequency by smart_buoy", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_manned_vessel <- any(grepl("radio_frequency by manned_vessel", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_manned_aircraft <- any(grepl("radio_frequency by manned_aircraft", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_on_shore_command_center <- any(grepl("radio_frequency by on_shore_command_center", filtered_iuu_data()$sensor_platform))
      radio_frequency_by_onboard <- any(grepl("radio_frequency by onboard", filtered_iuu_data()$sensor_platform))
      
      hydroacoustics_by_small_usv <- any(grepl("hydroacoustics by small usv", filtered_iuu_data()$sensor_platform))
      hydroacoustics_by_large_usv <- any(grepl("hydroacoustics by large usv", filtered_iuu_data()$sensor_platform))
      hydroacoustics_by_smart_buoy <- any(grepl("hydroacoustics by smart_buoy", filtered_iuu_data()$sensor_platform))
      hydroacoustics_by_manned_vessel <- any(grepl("hydroacoustics by manned_vessel", filtered_iuu_data()$sensor_platform))

      highly_sensitive_hydroacoustics_by_small_usv <- any(grepl("highly_sensitive_hydroacoustics by small usv", filtered_iuu_data()$sensor_platform))
      highly_sensitive_hydroacoustics_by_large_usv <- any(grepl("highly_sensitive_hydroacoustics by large usv", filtered_iuu_data()$sensor_platform))
      highly_sensitive_hydroacoustics_by_smart_buoy <- any(grepl("highly_sensitive_hydroacoustics_by_smart_buoy", filtered_iuu_data()$sensor_platform))
      highly_sensitive_hydroacoustics_by_manned_vessel <- any(grepl("highly_sensitive_hydroacoustics by manned_vessel", filtered_iuu_data()$sensor_platform))

      radar_by_small_usv <- any(grepl("radar by small usv", filtered_iuu_data()$sensor_platform))
      radar_by_large_usv <- any(grepl("radar by large usv", filtered_iuu_data()$sensor_platform))
      radar_by_smart_buoy <- any(grepl("radar by smart_buoy", filtered_iuu_data()$sensor_platform))
      radar_by_manned_vessel <- any(grepl("radar by manned_vessel", filtered_iuu_data()$sensor_platform))
      radar_by_manned_aircraft <- any(grepl("radar by manned_aircraft", filtered_iuu_data()$sensor_platform))
      radar_by_onboard <- any(grepl("radar by onboard", filtered_iuu_data()$sensor_platform))

      observer_by_manned_vessel <- any(grepl("observer by manned_vessel", filtered_iuu_data()$sensor_platform))
      observer_by_onboard <- any(grepl("observer by onboard", filtered_iuu_data()$sensor_platform))
      
      
      # PAIRINGS TEXT -- found in text/pairings
      # want to display just the user selections, these are all the conditions
      # NOTE: ADD THE REST!!
      
      ui_elements <- list()
      
      ### Adding packaged pairings text --------------------------
      if (mid_range_camera_by_small_aerial_drone) {
        mid_range_camera_by_small_aerial_drone_text <- "text/pairings/mid_range_camera_by_small_aerial_drone_tool.md"
        if(file.exists(mid_range_camera_by_small_aerial_drone_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(mid_range_camera_by_small_aerial_drone_text)))
          
        }
      }
      
      if (long_range_camera_by_usv) {
        long_range_camera_by_usv_text <- "text/pairings/long_range_camera_by_usv_tool.md"
        if(file.exists(long_range_camera_by_usv_text)) {
          ui_elements <- append(ui_elements, list(includeMarkdown(long_range_camera_by_usv_text)))

        }
      }

      
      
      
      ### Previous individual unpaired text files 
      # If 'long_range_camera' is found, add its content to the list -------
      # if (long_range_camera) {
      #   #print("Long range camera found")
      #   long_range_camera_text <- "text/long_range_camera_tool.md"
      #   if(file.exists(long_range_camera_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(long_range_camera_text)))
      #     
      #   }
      # }
      # 
      # # # # If 'aerial_drone' is found, add its content to the list
      # if (aerial_drone) {
      #   aerial_drone_text <- "text/aerial_drone_tool.md"
      #   if(file.exists(aerial_drone_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(aerial_drone_text)))
      #   }
      # }
      # 
      # 
      # # If 'hydroacoustics' is found, add its content to the list
      # if (hydroacoustics) {
      #   hydroacoustics_text <- "text/hydroacoustics_tool.md"
      #   if(file.exists(hydroacoustics_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(hydroacoustics_text)))
      #   }
      # }
      # 
      # # If 'onboard observer' is found, add its content to the list
      # if (onboard_observer) {
      #   onboard_observer_text <- "text/onboard_observer_tool.md"
      #   if(file.exists(onboard_observer_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(onboard_observer_text)))
      #   }
      # }
      # 
      # # If 'radar' is found, add its content to the list
      # if (radar) {
      #   radar_text <- "text/radar_tool.md"
      #   if(file.exists(radar_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(radar_text)))
      #   }
      # }
      # 
      # if (radio_frequency) {
      #   radio_frequency_text <- "text/radio_frequency_tool.md"
      #   if(file.exists(radio_frequency_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(radio_frequency_text)))
      #   }
      # }
      # 
      # if (manned_aircraft) {
      #   manned_aircraft_text <- "text/manned_aircraft_tool.md"
      #   if(file.exists(manned_aircraft_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(manned_aircraft_text)))
      #   }
      # }
      # 
      # if (manned_vessel) {
      #   manned_vessel_text <- "text/manned_vessel_tool.md"
      #   if(file.exists(manned_vessel_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(manned_vessel_text)))
      #   }
      # }
      # 
      # if (on_shore_command_center) {
      #   on_shore_command_center_text <- "text/on_shore_command_center_tool.md"
      #   if(file.exists(on_shore_command_center_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(on_shore_command_center_text)))
      #   }
      # }
      # 
      # if (smart_buoy) {
      #   smart_buoy_text <- "text/smart_buoy_tool.md"
      #   if(file.exists(smart_buoy_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(smart_buoy_text)))
      #   }
      # }
      # 
      # if (usv) {
      #   usv_text <- "text/usv_tool.md"
      #   if(file.exists(usv_text)) {
      #     ui_elements <- append(ui_elements, list(includeMarkdown(usv_text)))
      #   }
      # }
      # 
      # 
      # if no pairings
      if (no_pairings) {
        no_pairings_text <- "text/no_pairings_tool.md"
        if(file.exists(no_pairings_text)) {
          # ui_elements <- append(ui_elements, list(includeMarkdown(no_pairings_text)))
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
    
    
    
    ###### SATELLITE FILTERING ---------------------------------------
    # filtering the satellite data by the granularity of selected iuu type, by cost, and by delivery
    
    filtered_sat_data <- reactive({
      # Exit early if input not yet selected
      if(is.null(input$iuu_type_input) || is.null(input$range_input)) {
        return(data.frame())
      }
      
      # determining the granularity of iuu selection
      granularity <- iuu_type_index %>%
          filter(iuu_type == input$iuu_type_input) 
      
      get_granularity_index <- granularity$granularity_index

      # this might not have been necessary, but was following the same logic as above
      selected_columns_sat <- c("satellites", "granularity_index", "cost", "delivery")
      selected_sat_df <- satellites %>%
        select(all_of(selected_columns_sat))
      
      
      # determining all the granularity values
      for (col_name in names(selected_sat_df)[2]) {
        column_values <- selected_sat_df[[col_name]] # for each column name, determines all the column values
        
      # Identify row indices where values match the selected iuu type's granularity
        
        same_granularity <- which(column_values == get_granularity_index) 
        
      }
      
      # filtering the satellite data by iuu type/granularity, cost, and delivery
      # Note, again this data table won't be shown in the UI ultimately, but is very helpful for
      # ensuring output is correct and logic is sound
      
      if (!is.null(input$iuu_type_input)) {
        # there was also probably an easier way to do this but trial and error got me here
        # data <- data[data$granularity_index == get_granularity_index, ]
        data <- selected_sat_df[same_granularity, ]
      }
      
      if (input$sat_cost_input) {
        # Filter dataset for rows where cost is 1
        # This means that when switch is flipped, free options will appear
        data <- data[data$cost == 0, ]
      } 
      
      if (input$sat_delivery_input) {
        # Filter dataset for rows where delivery is 1
        # This means that when switch is flipped, near-time delivery options will appear
        data <- data[data$delivery == 1, ]
      } 
      
      data
      
    })

    
    #### Satellite table filter
    # To remove later, but helpful to check output filtering
    
    output$sat_table_output <- renderDataTable({
      filtered_sat_data() 
    }, options = list(pageLength = 10))
    

    
    # Still need to add text descriptions
  
    output$satellite_output <- renderUI({
      
      maxar <- any(grepl("Maxar", filtered_sat_data()$satellites))
      blacksky <- any(grepl("BlackSky", filtered_sat_data()$satellites))
      mda_radarsat <- any(grepl("MDA Radarsat", filtered_sat_data()$satellites))
      capella <- any(grepl("Capella", filtered_sat_data()$satellites))
      unseen_labs <- any(grepl("Unseen Labs", filtered_sat_data()$satellites))
      iceye <- any(grepl("Iceye", filtered_sat_data()$satellites))
      planet <- any(grepl("Planet", filtered_sat_data()$satellites))
      sentinel_1 <- any(grepl("Sentinel-1", filtered_sat_data()$satellites))
      sentinel_2 <- any(grepl("Sentinel-2", filtered_sat_data()$satellites))
      landsat_8_9 <- any(grepl("Landsat 8 & 9", filtered_sat_data()$satellites))
      viirs <- any(grepl("VIIRS", filtered_sat_data()$satellites))
      # adding a file to indicate the condition when no satellite options appear 
      no_satellites <- (nrow(filtered_sat_data()) == 0)
      
      
      ui_elements_2 <- list()
      
      # If Maxar is an option, add its info to the list
      if (maxar) {
        maxar_text <- "text/maxar_tool.md"
        if(file.exists(maxar_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(maxar_text)))
        }
      }
      
      # If Blacksky is an option, add its info to list, etc.
      if (blacksky) {
        blacksky_text <- "text/blacksky_tool.md"
        if(file.exists(blacksky_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(blacksky_text)))
        }
      }
      
      if (mda_radarsat) {
        mda_radarsat_text <- "text/mda_radarsat_tool.md"
        if(file.exists(mda_radarsat_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(mda_radarsat_text)))
        }
      }
      
      if (capella) {
        capella_text <- "text/capella_tool.md"
        if(file.exists(capella_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(capella_text)))
        }
      }
      
      if (unseen_labs) {
        unseen_labs_text <- "text/unseen_labs_tool.md"
        if(file.exists(unseen_labs_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(unseen_labs_text)))
        }
      }
      
      if (iceye) {
        iceye_text <- "text/iceye_tool.md"
        if(file.exists(iceye_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(iceye_text)))
        }
      }
      
      if (planet) {
        planet_text <- "text/planet_tool.md"
        if(file.exists(planet_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(planet_text)))
        }
      }
      
      if (sentinel_1) {
        sentinel_1_text <- "text/sentinel_1_tool.md"
        if(file.exists(sentinel_1_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(sentinel_1_text)))
        }
      }
      
      if (sentinel_2) {
        sentinel_2_text <- "text/sentinel_2_tool.md"
        if(file.exists(sentinel_2_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(sentinel_2_text)))
        }
      }
      
      if (landsat_8_9) {
        landsat_8_9_text <- "text/landsat_8_9_tool.md"
        if(file.exists(landsat_8_9_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(landsat_8_9_text)))
        }
      }
      
      if (viirs) {
        viirs_text <- "text/viirs_tool.md"
        if(file.exists(viirs_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(viirs_text)))
        }
      }
      
      
      # If no satellite options available, indicate this
      if (no_satellites) {
        no_satellites_text <- "text/no_satellites_tool.md"
        if(file.exists(no_satellites_text)) {
          ui_elements_2 <- append(ui_elements_2, list(includeMarkdown(no_satellites_text)))
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