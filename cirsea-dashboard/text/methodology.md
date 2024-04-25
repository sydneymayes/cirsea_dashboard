
**Overview:**

This dashboard was built in R Shiny. The data that informs it were acquired from literature reviews, interviews, market research, and industry knowledge from Skylight and AI2. All data and code are available in our public [GitHub repository](https://github.com/sydneymayes/cirsea_dashboard).

**Tool Recommendation Logic:**

The IUU Tool provides possible IUU monitoring solutions based on IUU type, jurisdiction, cost, and data type. Monitoring option outputs include sensor and platform pairings as well as satellites. The following will step through how matching occurs behind the scenes.

1. IUU Types have been assigned a granularity score on a scale from 1 to 5. 1 represents the least granular information needed to detect an event (e.g., geographic location) and 5 represents the most granular data required (e.g., species identification).

2. Sensor ranges have been determined for each level of granularity (i.e., within how many kilometers a sensor must be to detect information at each of the granularity levels). Characteristics of sensors including approximated costs and what data they collect are also recorded.

3. Platform ranges are determined by multiplying platform speed by endurance. Ranges for platforms that must return to shore after monitoring are divided in half. 

4. Sensors can gather information and are paired with a platform that directs the sensor to where it needs to be to collect data. Therefore, sensor ranges have been added to platform ranges and a monitoring area has been calculated based on this combined range. We assume that a circle area surrounding a given platform’s deployment location represents the possible monitoring area for a sensor/platform pairing.

5. Satellites are considered prepackaged sensors and are considered separately. Each satellite is also assigned a granularity score as well as a cost (free or not) and delivery type (near-time delivery or not).

6. With IUU types, sensor/platform pairings, and satellites all associated with a granularity score, matching is possible based on shared scores. Users may select an IUU type and range of interest and are presented with potential sensor/platform pairings and satellite monitoring options. A user may further filter results by specifying cost and data interests.

*The [full report](https://bren.ucsb.edu/projects/illegal-unreported-and-unregulated-fishing-empowering-effective-and-efficient) on this project may be found on the Bren School website. Please feel free to contact the CIRSEA team with any questions.*


