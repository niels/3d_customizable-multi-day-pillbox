/*
    This work, "Customizable (Multi-) Day Pillbox" (https://www.printables.com/model/12345-customizable-multi-day-pillbox),
    is adapted from "Customizable Pill Dosette Box" (https://www.printables.com/model/70577-customizable-pill-dosette-box)
    by @einarjh (https://www.printables.com/@einarjh_110431),
    used under CC-BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
    
    "Customizable (Multi-) Day Pillbox" (https://www.printables.com/model/12345-customizable-multi-day-pillbox)
    is licensed under CC-BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)
    by Niels Ganser (https://www.printables.com/@niels_1017960).
*/

/*
    Modify the below parameters to customize your pillbox.
*/

// How many days should your pillbox contain?
days = 7;

// How many chambers should each day have? In other words: how many "portions" of pills
// are taken per day.
chambers = 2;

// The inner dimensions of each chamber (remember: each day has multiple chambers), in mm.
chamberWidth = 21;
chamberHeight = 20;
chamberLength = 40;

// The thickness of thin walls. Thin walls are those seperating the chambers within a day, as
// well as the north and south facing outer walls.
thinWall = 1.5;

// The thickness of thick walls. Thick walls are those separating the days as well as the east and
// west facing outer walls. Thick walls must be able to contain the lidChannel.
thickWall = 3;

// The channel to cut out from the thick walls to accomodate the sliding lids.
lidChannel = 1;

// The names of the weekdays to engrave into the front of the pillbox.
//
// If you modify your pillbox to contain less than 7 days, only the first X names will be picked.
// Modify the below list accordingly if, for example, you want to print only a Sat–Sun.
dayNames = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

/*
    This concludes the safe-ish to edit portion of the file. Proceed with caution.
*/

difference() {
    union() {
        outerBox();
        days();
    } 
                
    for(dayIdx = [1:days]) {
        translate([
            thickWall + (chamberWidth + thickWall) * (dayIdx - 1) + chamberWidth / 2,
            (chamberLength * chambers) + (thinWall * chambers) + thinWall -1,
            (chamberHeight / 2) - 2
        ])
        rotate([90, 0, 180])
        linear_extrude(height=1) {
            text(dayNames[days - dayIdx], font = "sans-serif:style=Bold", halign="center", size = 8);
        }
    }
}

module chamber(chamberIdx) {
    union()  {
        // Separator between chambers.
        translate([
            0,
            thinWall + (chamberLength * chamberIdx) + (thinWall * (chamberIdx - 1)),
            thickWall
        ])
        cube([chamberWidth, thinWall, chamberHeight]);
        
        // Slope (to ease sliding out pills).
        translate([
            0,
            thinWall + (chamberLength * chamberIdx) + (thinWall * (chamberIdx - 1)),
            thickWall
        ]) slope();
    }
}

module chambers() {
    for(chamberIdx = [1:chambers]) {
        chamber(chamberIdx);
    }
}

module days() {
    for(dayIdx = [1:days]) {
        day(dayIdx);
    }
}

module day(dayIdx) {
    union()  {
        difference() {
            // Separator between days.
            translate([
                thickWall + (chamberWidth * dayIdx) + (thickWall * (dayIdx - 1)),
                thinWall ,
                thickWall
            ])
            cube([
                thickWall,
                (chamberLength * chambers) + (thinWall * chambers),
                chamberHeight + thickWall
            ]);
                
            // Lid channels.
            translate([
                (thickWall - lidChannel) + (chamberWidth * (dayIdx - 1)) + (thickWall * (dayIdx - 1)),
                thinWall,
                chamberHeight + thickWall
            ])
            cube([
                chamberWidth + (lidChannel * 2),
                (chamberLength * chambers) + (thinWall * chambers),
                lidChannel
            ]);
            translate([
                (thickWall - lidChannel) + (chamberWidth * dayIdx) + (thickWall * dayIdx),
                thinWall,
                chamberHeight + thickWall
            ])
            cube([
                chamberWidth + (lidChannel * 2),
                (chamberLength * chambers )+ (thinWall * chambers),
                lidChannel
            ]);
        }
    }
        
    // Individual pill chambers.
    translate([
        thickWall + (chamberWidth * (dayIdx - 1)) + (thickWall * (dayIdx - 1)),
        0,
        0
    ])
    chambers();
}

module outerBox() {
    difference() {
        // Outer box = all (inner) chambers plus inner walls plus outer walls.
        cube([
            (chamberWidth * days) + (thickWall * 2) + (thickWall * (days - 1)),
            (chamberLength  * chambers) + (thinWall * 2)  + (thinWall * (chambers - 1)),
            chamberHeight + (thickWall *2)
        ]);
        
        // Inner box except for lid.
        translate([thickWall, thinWall, thickWall])
        cube([
            (chamberWidth * days) + (thickWall * (days - 1)),
            (chamberLength  * chambers) + (thinWall * (chambers - 1)),
            chamberHeight
        ]);
        
        // Lid top.
        translate([thickWall, thinWall, chamberHeight + thickWall])
        cube([
            (chamberWidth * days) + (thickWall * (days - 1)),
            (chamberLength  * chambers) + (thinWall * chambers),
            thickWall
        ]);
        
        // Lid channels.
        translate([thickWall - lidChannel, thinWall, chamberHeight + thickWall])
        cube([
            (chamberWidth * days) + (thickWall * (days - 1)) + (lidChannel * 2),
            (chamberLength  * chambers) + (thinWall * chambers),
            lidChannel
        ]);
    }
}

module slope() {
    translate([0, -chamberHeight / 2, 0])
    difference() {
        cube([chamberWidth, chamberHeight / 2, chamberHeight / 2]);
        translate([0, 0, chamberHeight / 2])
        rotate([90, 90, 90])
        cylinder(d1 = chamberHeight, d2 = chamberHeight, h = chamberWidth, $fn = 100);
    }
}