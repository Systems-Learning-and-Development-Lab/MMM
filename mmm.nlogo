extensions [send-to fetch import-a table]; profiler]

globals [
  tick-count ; count how many turns this model has executed ("go" procedure invoked)
  current-background-color ; gets updated when user clicks "paint-world" button
  wall-collision-count ; count wall collisions for each population.
  gravity-acceleration-x   ; acceleration of gravity on x axis
  tick-advance-amount                 ; the amount by which ticks advance each turn
  maxballs                       ; possibly omit later, to prevent balls slowing down too much so that it's visible and confuses the students about speed
  deltaSpeed    ;  value to increase or decrease speed
  max-speed     ; max allowed speed in system (recursive speed increase may blow up the variable)
  lookAhead  ; distance to check ahead if near wall
  field-color
  field-count ; counts the number of different fields (was "clusters")
  flash-time     ; length of time of flash
  eps-collision  ; how deep the intersection of balls can be to be considered collision
  balls-by-population ; for fast access of balls belonging to certain population
  ball-count-in-populations
  amount-of-block-spaces ; how many blocks spaces in nettango for configuring populations
  ball-shape-update-procedure-lookup ; which procedure to run to update shape of turtle, depends on shape name
  run-me-if-i-throw-error-then-nettango-has-recompiled ; used to fix a bug in nettango which throws error if lambdas are ran after netlogo has been recompiled
  animation-procedure-lookup-by-name ; table that holds anonymous procedures that runs the animation, keys are string name of animation
  prev-global-variable-values
  global-variable-changed-lookup ; which procedure to run incase a specific global property has been changed.
  last-tick-count-display-was-updated

  ;==== ast ====
  ast-by-population
  curr-ast-by-population       ; used for comparison of prev ast to check for changes
  prev-ast-by-population       ; used for comparison to check for changes
  ast-lookup-table-run-node    ; links node name to function that runs node
  ast-lookup-table-parse-node  ; links node name to function that parses node

  ;==== counters ====
  counter-width
  counters-information-gfx-overlay ; breed that references 2 gfx-overlay turtles that display information for counter
  ball-count-in-counters ; table that keeps track of ball count in all counters

  ;==== population properties ====
  ball-population-properties ; list that holds properties for each population. Each index is a different property. Check report procedure "property-index"
  prev-ball-population-properties ; previous values of properties. used for checking if value has changed.
  property-change-procedure-lookup ; which procedure to run incase a specific property has been changed.
  default-colors-for-ball-populations
  population-to-set-properties-for-in-ui ; which population is selected in the ball pallet in ui
  current-population-properties-are-being-set-for-in-nettango ; keeps track of which population we are setting properties for in nettango
  nettango-what-ball-meets-in-if-ball-meets-block ; used to keep track for which entity (ball meets) the interaction block is defined for

  ;==== log =====
  log-history ; keeps track of all log history. need this because netlogo web can not append to a file, so need to write whole log every time
  log-picture-count ; keeps track how many pictures logged so far so the file can be named with picture number in ascending order
  log-filename  ; will hold filename
  log-filename-photo ; will hold photo file name
  prev-command-name ; will hold the prev command printedin log file (to avoid double logging)
  prev-line  ; will hold the last line printedin log file

  ;===== lennard jones ======
  repulsion-strength
  attraction-strength
  LJeps   ; Lennard Jones constants
  LJsigma ; Lennard Jones constants

  ;======= brush ===========
  brush-shape                           ; square or circle
  brush-type                            ; what is brush drawing?
  center-patch-of-drawn-shape           ; keeps track of patch brush first clicked on when shape was first drawn.
  patches-affected-by-drawn-shape       ; patches that would be drawn on if user were to draw shape right now
  gfx-displaying-patches-affected-by-drawn-shape    ; turtles that only serve to display boundaries of shape currently being configured
  mouse-xy-when-brush-was-pressed-down  ; x,y coordinates when brush was first clicked
  shape-drawn-by-brush                  ; circle,rectangle,line,square
  -brush-border-outline                 ; gfx turtle displaying which patches will get drawn onby brush
  -brush-cursor                         ; gfx turtle displaying brush cursor
  brush-style                           ; is brush drawing free-form or a shape
  brush-type-icon                       ; icon top right of model displaying what brush is drawing
  brush-draw-erase-mode-icon            ; icon top right of model displaying if brush is set to draw, erase, or configuring shape
  brush-icon-size
  brush-icon-transparency-normalized
  brush-in-draw-mode                    ; true if brush is drawing, false if erasing
  mouse-down?-when-brush-was-last-activated
  mousexy-when-brush-was-last-activated
  current-mousexy
  current-mouse-down?
  current-mouse-inside?
  patches-drawn-on-since-brush-was-held-down    ; keeps track if you do not want to draw twice on the same patch since brush was pressed down.
  counter-number-drawn-by-brush                 ; counter number currently being drawn by brush
  last-patch-brush-configured-field-on
  patches-field-drawn-on
  brush-activated-after-model-was-advanced      ; to know if display should be updated because model isnt running which means display isn't updated in "go" procedure
  click-count-when-radio-buttons-were-first-clicked ; used for radio buttons for brush. keeps track of what order brush buttons were clicked so the right button is unpressed
  brush-radio-buttons-click-count ; increased when one of the brush buttons is clicked, used to keep track of which button was pressed last

  ;======= AST VARIABLES =========
  ast-root
  current-node
  last-added-node
  nodes-by-id
  last-used-nodes-by-id
  id-counter

  ;====== DEPRECATED/ UNUSED variables ===============
  ;heading-acceleration     ; direction of field
  ;avg-speed-init avg-energy-init      ; initial averages
  ;avg-speed avg-energy                ; current averages
  ;particle-mass
  ;temperature
  ;volume
  ;pressure
  ;outside-energy
  ;lost-balls                     ; particles that have escaped the pull of gravity (reached the top of the World & View)
                                      ; these particles are removed from the simulation
  ;percent-lost-balls
  ;max-tick-advance-amount             ; the largest a tick length is allowed to be
  ;obstacles
  ;field-width
;  max-field-spread
;  counter-color
  ;counter-time-window ; number of time units over which to sum balls on counter
  ;counter-delta-time  ; will count the time units
;  fixPrevFieldPatch  ; flag to determine if prev mouse position needs to be added to field
]

; order of breeds determines layering of turtles.
breed [ counter-information-gfx a-counter-information-gfx]
breed [ batteries battery ]
breed [ counters counter]
breed [ flashes flash ]      ; a gfx breed only used to animate a flash
breed [ arrows arrow]
breed [ halos halo]
breed [ ball-compound-shapes ball-compound-shape]
breed [ balls ball]
breed [ animations animation]
breed [ erasers eraser ]
breed [gfx-overlay a-gfx-overlay] ; turtles used to diplay gfx
breed [brush-border-outlines brush-border-outline] ; gfx for brush outline
breed [brush-cursors brush-cursor] ; gfx for brush cursor

undirected-link-breed [compound-shapes compound-shape]

flashes-own [birthday]       ; flashes only last for a short period and then disappear.
                             ; their birthday lets us keep track of when they were created and
                             ; when we need to remove them.
animations-own [
  birthday                   ; tick count animation was created
  animate                    ; anonymous procedure to animate animation, use 'ask -animation [run animate]'
  data                       ; data can be anything the animation needs. table variable
  -name                      ; temporarily used because of nettango bug
]

balls-own
[
  population-num             ; Which population the ball belongs to
  speed mass energy          ; particle info
  tick-count-move-enabled     ; tick count when move was enabled to move if in blocks set to "Move X Steps"
  last-tick-wall-collision-occured    ; keep track last tick wall collision occured to reduce calculation when changing speed if collision occured
  balls-collided-with
  force-x-sum                     ; used to efficiently calculate repel and attract forces on ball at end of tick. reset to 0 at start of tick
  force-y-sum                     ; used to efficiently calculate repel and attract forces on ball at end of tick. reset to 0 at start of tick
;  last-collision             ; keeps track of last particle this particle collided with
;  table
;  leader                     ; for stick togather slider
;  wall-hits                  ; # of wall hits during this clock cycle
;  momentum-difference        ; used to calculate pressure from wall hits
;  momentum-instant           ; used to calculate pressure
;  stuck-on-wall?             ; pays attention if the balls is stuck to exclude him from movement
;  turn-amount                ; This is used to make all of the nodes in a cluster turn by
                              ; the same number of degrees.  Each leader chooses a random
                              ; amount, then everyone else uses the amount from their leader.
;  stick-to-wall?
]

erasers-own [ pressure? ]    ;new

patches-own
[
  field-x             ; vector  field_x and field_y define the direction and strength of the electric field within the patch
  field-y             ; vector  field_x and field_y define the direction and strength of the electric field within the patch
  accum-x             ; accumulates vector  field_x for gobal field computation
  accum-y             ; accumulates vector  field_y for gobal field computation
  accum-w             ; accumulates weights  for gobal field computation
  field-number        ; holds the component number of the field (was "cluster")
  has-wall            ; true if patch has wall
;  cluster             ; GIGI  - DO WE NEED THIS NOW? holds the label (patch) of the electric component. we need this to ensure balls leaveand return to same component/cluster  ALSO used for counter numbering
;  cluster-number      ; holds the label (number) of the electric component. we need this to ensure balls leaveand return to same component/cluster  ALSO used for counter numbering
]

counters-own
[
  counter-number      ; holds the counter number
]

to initialize-properties-for-populations [populations]
  foreach populations [population -> initialize-ball-population-properties population]
end

to crt-pop
  ; only used in desktop version, since we dont have blocks to define population properties.
  initialize-properties-for-populations [1 2]
  let pop-properties table:make
  table:put pop-properties 1 table:from-list
    [
      ["size" 0.5]
      ["wall-heading" "collide"]
      ["wall-speed" "collide"]
      ["ball-heading" "collide"]
      ["ball-speed" "collide"]
      ["other-ball-heading" "collide"]
      ["other-ball-speed" "collide"]
      ["gravity" 0]
      ["electric-field" 40]
      ["move" true]
      ["color" red]
      ["name" "wow"]
    ]
  table:put pop-properties 2 table:from-list
    [
      ["size" 0.5]
      ["wall-heading" "collide"]
      ["wall-speed" "collide"]
      ["ball-heading" "collide"]
      ["ball-speed" "collide"]
      ["other-ball-heading" "collide"]
      ["other-ball-speed" "collide"]
      ["gravity" 0]
      ["electric-field" 0]
      ["move" true]
      ["color" blue]
    ]
  foreach table:keys pop-properties [population ->
   let properties table:get pop-properties population
   foreach table:keys properties [property ->
      let value table:get properties property
      set-prop population property value
   ]
  ]
end

to throw-error-if-population-block-space-does-not-exist [population]
  run (word "let x [ -> configure-population-" population " ]")
end

to-report count-population-block-spaces
  let block-space-number 1
  carefully [
    loop [
      throw-error-if-population-block-space-does-not-exist block-space-number
      set block-space-number block-space-number + 1
    ]
  ] []
  report (block-space-number - 1)
end

to-report block-spaces-already-counted?
  report amount-of-block-spaces > 0
end

to-report amount-of-population-block-spaces
  report ifelse-value block-spaces-already-counted? [amount-of-block-spaces] [count-population-block-spaces]
end

to initialize-world
  initialize-global-values
  initialize-patches
end

to initialize-patches
  ask patches [set has-wall false]
end

to initialize-global-values
  set tick-count 0
  set ball-population-properties table:make
  set prev-ball-population-properties ball-population-properties
  set population-to-set-properties-for-in-ui "-"
  set default-colors-for-ball-populations [red blue lime orange violet yellow cyan pink brown green sky magenta turquoise gray ]
  set counters-information-gfx-overlay table:make
  set ball-count-in-counters table:make
  set last-patch-brush-configured-field-on nobody
  set patches-field-drawn-on []
  set brush-activated-after-model-was-advanced false
  set click-count-when-radio-buttons-were-first-clicked table:make
  set brush-radio-buttons-click-count 0
  set log-history ""
  set log-picture-count 0
  set current-background-color background-color
  set wall-collision-count table:make
  set balls-by-population table:make
  set maxballs 200
  set deltaSpeed 0.5;
  set max-speed 20
  set lookAhead 0.6
  set field-color 87
  set field-count 0
  set counter-width 1.25
  set flash-time  15
  set-default-shape flashes "square"
  set repulsion-strength 100
  set attraction-strength 30
  set gravity-acceleration-x 0
  set eps-collision 0.99
  set tick-advance-amount 1 / 50   ; MAXIMUM possible value of ball speed. Change this if changed SLIDER in interface
  setup-logging  "LOGGING/logFile"  ; sets the log file name log-filename
  set prev-command-name "None"
  set prev-line "None"
  set LJeps 0.5  ; Lennard Jones constants
  set-default-shape halos "thin ring"
  set run-me-if-i-throw-error-then-nettango-has-recompiled [[] ->]
  initialize-ast
  set prev-global-variable-values global-variable-values
  initialize-ball-shape-update-procedure-lookup
  initialize-property-change-procedure-lookup
  initialize-global-variable-changed-lookup
  ;set max-field-spread 20 ; spread the field only within a radius  (max world is -26 <->  +26
  ;set counter-time-window 1000
  ;set counter-delta-time 0
end

to initialize-all-anonymous-procedures
  set run-me-if-i-throw-error-then-nettango-has-recompiled [[] ->]
  initialize-ast-run-lookup-table
  initialize-ast-parse-lookup-table
  initialize-property-change-procedure-lookup
  initialize-global-variable-changed-lookup
  initialize-ball-shape-update-procedure-lookup
  initialize-animation-anonymous-procedures
end

to initialize-animation-anonymous-procedures
  initialize-animation-procedure-lookup-by-name
  ask animations [initialize-animate-anonymous-procedure]
end

to-report animation-by-name [name]
  report table:get animation-procedure-lookup-by-name name
end

to initialize-all-lookup-tables-if-nettango-has-recompiled
  ; temporary fix to solve a nettango bug, after nettango is recompiled
  ; then error "Importing and then running lambdas is not supported!" is thrown.
  ; It happens if an anonymous procedure that was stored in a variable before nettango
  ; was recompiled is ran, so all anonymous procedures need to be initialized.
  carefully [
    run run-me-if-i-throw-error-then-nettango-has-recompiled ]
  [
    initialize-all-anonymous-procedures
  ]
end

to initialize-animation-procedure-lookup-by-name
  ; temporary procedure due to nettango bug
  set animation-procedure-lookup-by-name table:from-list (list
    (list "mark" [[] -> remove-animation-if-past-lifespan])
    (list "rotate" [[] -> flash-animation])
    (list "flash" [[] -> rotate-animation])
    (list "inflate" [[] -> increase-animation-size])
    (list "draw" [[] -> remove-animation-if-past-lifespan])
  )
end

to-report global-variable-values
  report table:from-list (list
    (list "show-name" show-name)
    (list "color-speed" color-speed)
  )
end

to initialize-global-variable-changed-lookup
  set global-variable-changed-lookup table:from-list (list
    (list "show-name" [[new-value] -> ifelse new-value [show-balls-labels] [hide-balls-labels]])
    (list "color-speed" [[new-value] -> if not new-value [ask balls [update-ball-color]]])
  )
end

to initialize-property-change-procedure-lookup
  set property-change-procedure-lookup table:from-list (list
    (list "shape" [[population] -> update-shapes-of-population population])
    (list "size" [[population] -> update-size-of-population population])
    (list "color" [[population] -> update-color-of-population population])
    (list "secondary-colors" [[population] -> update-color-of-population population])
  )
end

to initialize-ball-shape-update-procedure-lookup
  set ball-shape-update-procedure-lookup table:from-list (list
    (list "molecule-ha" [[] -> update-compound-shape "molecule-ha" ["h" "a"] ["h" "a"]])
    (list "molecule-ao" [[] -> update-compound-shape "molecule-ao" ["a" "o"] ["a" "o"]])
    (list "molecule-no2" [[] -> update-compound-shape "molecule-no2" ["n" "o2"] ["o2" "n"]])
    (list "molecule-h2o" [[] -> update-compound-shape "molecule-h2o" ["h2" "o"] ["o" "h2"]])
    (list "molecule-co2" [[] -> update-compound-shape "molecule-co2" ["c" "o2"] ["o2" "c"]])
    (list "molecule-nh3" [[] -> update-compound-shape "molecule-nh3" ["n" "h3"] ["n" "h3"]])
    (list "molecule-ch4" [[] -> update-compound-shape "molecule-ch4" ["c" "h4"] ["c" "h4"]])
    (list "molecule-candle" [[] -> update-compound-shape "molecule-candle" ["c" "h"] ["c" "h"]])
    (list "molecule-alcohol" [[] -> update-compound-shape "molecule-alcohol" ["c2" "h5" "oh"] ["c2" "oh" "h5"]])
  )
end

to default-shape-update
  kill-existing-compound-shapes
  set shape prop "shape"
end

to-report population-colors [population]
  report (sentence pprop population "color" pprop population "secondary-colors")
end

to-report shape-update-procedure
  report table:get-or-default ball-shape-update-procedure-lookup (prop "shape") [[] -> default-shape-update]
end

to update-compound-shape [base-name part-names view-order]
  set shape "empty"
  kill-existing-compound-shapes
  create-compound-shapes base-name part-names view-order
end

to kill-existing-compound-shapes
  ask compound-shape-neighbors [die]
  ask my-compound-shapes [die]
end

to-report add-default-colors-if-not-defined [colors -length]
  let amount-of-colors-missing -length - length colors
  report (sentence colors n-values amount-of-colors-missing [gray])
end

to create-compound-shapes [base-name part-names view-order]
  let amount-of-compound-shapes length part-names
  let colors ball-colors
  if length colors < length part-names [set colors add-default-colors-if-not-defined colors length part-names]
  foreach range amount-of-compound-shapes [index ->
    create-compound-shape base-name (item index view-order) (item (position (item index view-order) part-names) colors)
  ]
end

to create-compound-shape [base-name part-name -color]
  let shape-name (word base-name "-" part-name)
  hatch-ball-compound-shapes 1 [
    set shape shape-name
    set size [size] of myself
    set color -color
    set label ""
    set label-color white
    create-compound-shape-with myself [
      tie
    ]
  ]
end

to-report ball-colors
  report population-colors population-num
end

to initialize-ast
  set ast-root table:make
  set current-node false
  set last-added-node false
  set nodes-by-id []
  set last-used-nodes-by-id []
  set id-counter 0
  set ast-by-population table:make
  set curr-ast-by-population table:make
  set prev-ast-by-population table:make
  initialize-ast-run-lookup-table
  initialize-ast-parse-lookup-table
end

to initialize-ast-run-lookup-table
  set ast-lookup-table-run-node table:from-list (list
    ;(list "" [[node population objects] -> func node population objects])
    (list "properties" [[node population objects] -> run-properties-clause node population])
    (list "actions" [[node population objects] -> run-actions-clause node population])
    (list "interactions" [[node population objects] -> run-interactions-clause node population])

    (list "color" [[node population objects] -> run-color-block node population])
    (list "size" [[node population objects] -> run-property-block node population])
    (list "shape" [[node population objects] -> run-property-block node population])
    (list "initial-heading" [[node population objects] -> run-property-block node population])
    (list "initial-speed" [[node population objects] -> run-property-block node population])
    (list "name" [[node population objects] -> run-property-block node population])

    (list "move-forever" [[node population objects] -> run-move-forever-block node population])
    (list "move-x-steps" [[node population objects] -> run-move-x-steps-block node population])

    (list "if-ball-meets" [[node population objects] -> run-if-ball-meets-block node population])
    (list "objects" [[node population objects] -> run-if-ball-meets-block-objects-clause node population])
    (list "then" [[node population objects] -> run-if-ball-meets-block-then-clause node population objects])

    (list "wall" [[node population objects] -> run-wall-block node population])
    (list "gravity-field" [[node population objects] -> run-gravity-field-block node population])
    (list "electric-field" [[node population objects] -> run-electric-field-block node population])
    (list "ball-same-population" [[node population objects] -> run-ball-same-population-block node population])
    (list "ball-from-population" [[node population objects] -> run-ball-other-population-block node population])

    (list "heading" [[node population objects] -> run-heading-block node population objects])
    (list "speed" [[node population objects] -> run-speed-block node population objects])
    (list "field-strength" [[node population objects] -> run-field-strength-block node population objects])
    (list "create-ball" [[node population objects] -> run-create-balls-block node population])
    (list "add" [[node population objects] -> run-add-block node population])
    (list "disappear" [[node population objects] -> run-disappear-block node population objects])
    (list "kill-balls-that-meet" [[node population objects] -> run-kill-balls-that-meet-block node population objects])
    (list "chance" [[node population objects] -> run-chance-block node population objects])
    (list "if-collide" [[node population objects] -> run-if-collide-block node population objects])
    (list "if-in-radius" [[node population objects] -> run-if-in-radius-block node population objects])
    (list "repeat" [[node population objects] -> run-repeat-block node population objects])
    (list "mark" [[node population objects] -> run-mark-block node population objects])
    (list "draw" [[node population objects] -> run-draw-block node population objects])
    (list "animate" [[node population objects] -> run-animate-block node population objects])
    (list "at-least-x-ticks" [[node population objects] -> run-at-least-x-ticks-block node population objects])
  )
end

to initialize-ast-parse-lookup-table
  set ast-lookup-table-parse-node table:from-list (list
    (list "properties" [[node population objects] -> parse-properties-clause node population])
    (list "actions" [[node population objects] -> parse-actions-clause node population])
    (list "interactions" [[node population objects] -> parse-interactions-clause node population])

    (list "color" [[node population objects] -> parse-color-block node population])
    (list "size" [[node population objects] -> parse-property-block node population])
    (list "shape" [[node population objects] -> parse-property-block node population])
    (list "initial-heading" [[node population objects] -> parse-property-block node population])
    (list "initial-speed" [[node population objects] -> parse-property-block node population])
    (list "name" [[node population objects] -> parse-property-block node population])

    (list "move-forever" [[node population objects] -> parse-move-forever-block node population])
    (list "move-x-steps" [[node population objects] -> parse-move-x-steps-block node population])

    (list "if-ball-meets" [[node population objects] -> parse-if-ball-meets-block node population])
    (list "objects" [[node population objects] -> parse-if-ball-meets-block-objects-clause node population])
    (list "then" [[node population objects] -> parse-if-ball-meets-block-then-clause node population objects])

    (list "wall" [[node population objects] -> parse-wall-block node population])
    (list "gravity-field" [[node population objects] -> parse-gravity-field-block node population])
    (list "electric-field" [[node population objects] -> parse-electric-field-block node population])
    (list "ball-same-population" [[node population objects] -> parse-ball-same-population-block node population])
    (list "ball-from-population" [[node population objects] -> parse-ball-other-population-block node population])

    (list "heading" [[node population objects] -> parse-heading-block node population objects])
    (list "speed" [[node population objects] -> parse-speed-block node population objects])
    (list "field-strength" [[node population objects] -> parse-field-strength-block node population objects])
    (list "create-ball" [[node population objects] -> parse-create-balls-block node population])
    (list "add" [[node population objects] -> parse-add-block node population])
    (list "disappear" [[node population objects] -> parse-disappear-block node population objects])
    (list "kill-balls-that-meet" [[node population objects] -> parse-kill-balls-that-meet-block node population objects])
    (list "chance" [[node population objects] -> parse-chance-block node population objects])
    (list "if-collide" [[node population objects] -> parse-if-collide-block node population objects])
    (list "if-in-radius" [[node population objects] -> parse-if-in-radius-block node population objects])
    (list "repeat" [[node population objects] -> parse-repeat-block node population objects])
    (list "mark" [[node population objects] -> parse-mark-block node population objects])
    (list "draw" [[node population objects] -> parse-draw-block node population objects])
    (list "animate" [[node population objects] -> parse-animate-block node population objects])
    (list "at-least-x-ticks" [[node population objects] -> parse-at-least-x-ticks-block node population objects])
  )
end

to update-all-plots
  update-ball-population-plot
  update-ball-collisions-plot
end

to update-ball-population-plot
  set-current-plot "Ball Population"
  foreach population-numbers [population -> update-ball-population-in-plot population]
end

to update-ball-population-in-plot [population]
  set-ball-population-plot-pen population
  plotxy ticks ball-count-in-population population
end

to set-ball-population-plot-pen [population]
  let pen (word population)
  ifelse plot-pen-exists? pen [
    set-current-plot-pen pen ]
  [
    create-temporary-plot-pen pen
    set-plot-pen-color pprop population "color"
  ]
end

to update-ball-collisions-plot

end

to iterate-through-population-number-in-ui-by-ascending-circular-order
  let -population-numbers population-numbers
  ifelse is-a-population-selected-in-ui [
    let index-of-current-populaiton-in-ui position population-to-set-properties-for-in-ui -population-numbers
    set population-to-set-properties-for-in-ui
          item ((index-of-current-populaiton-in-ui + 1) mod (length -population-numbers)) -population-numbers ]
  [
    set population-to-set-properties-for-in-ui min -population-numbers
  ]
end

to-report population-numbers
  report table:keys ball-population-properties
end

to-report any-population-exists
  report length population-numbers > 0
end

to select-next-population-in-properties-ui
  if any-population-exists [
    iterate-through-population-number-in-ui-by-ascending-circular-order
  ]
end

to-report highest-population-number
  report max population-numbers
end

to-report unused-population-number-higher-than-existing-population-numbers
  ifelse any-population-exists [
    report highest-population-number + 1]
  [
    report 1
  ]
end

to set-new-population-to-set-properties-for-in-ui
  set population-to-set-properties-for-in-ui unused-population-number-higher-than-existing-population-numbers
end

to-report default-color-for-population [population-number]
  let -population-colors map [population -> pprop population "color"] population-numbers
  let default-colors-not-used-by-any-population filter [default-color -> not member? default-color -population-colors] default-colors-for-ball-populations
  ifelse not empty? default-colors-not-used-by-any-population [
    report first default-colors-not-used-by-any-population ]
  [
    report item (population-number mod length default-colors-not-used-by-any-population) default-colors-not-used-by-any-population
  ]
end

to-report is-a-population-selected-in-ui
  report is-number? population-to-set-properties-for-in-ui
end

to-report any-record-of-radio-button-requesting-to-be-clicked? [button]
  report not table:has-key? click-count-when-radio-buttons-were-first-clicked button
end

to-report is-first-time-radio-button-is-activated [button]
  report any-record-of-radio-button-requesting-to-be-clicked? button
end

to increase-radio-button-press-count
  set brush-radio-buttons-click-count brush-radio-buttons-click-count + 1
end

to record-radio-button-clicked [button]
  increase-radio-button-press-count
  table:put click-count-when-radio-buttons-were-first-clicked button brush-radio-buttons-click-count
end

to remove-record-of-buttons-clicked-previous-to [button]
  let first-time-button-was-pressed table:get click-count-when-radio-buttons-were-first-clicked button
  foreach (filter [key -> (key != button) and (table:get click-count-when-radio-buttons-were-first-clicked key < first-time-button-was-pressed)] table:keys click-count-when-radio-buttons-were-first-clicked )
    [key -> table:remove click-count-when-radio-buttons-were-first-clicked key]
end

to update-record-of-when-brush-radio-button-was-first-clicked [button]
  ifelse any-record-of-radio-button-requesting-to-be-clicked? button [
    record-radio-button-clicked button]
  [
    remove-record-of-buttons-clicked-previous-to button
  ]
end

to-report should-release-brush-radio-button? [button]
  ;should be called from a procedure ran by a brush button in the interface, only once per button name
  unselect-brush-radio-button-if-another-button-was-clicked-more-recently button
  report not table:has-key? click-count-when-radio-buttons-were-first-clicked button
end

to unselect-brush-radio-button-if-another-button-was-clicked-more-recently [button]
  update-record-of-when-brush-radio-button-was-first-clicked button
  if another-brush-radio-button-was-clicked-more-recently button [
    deselect-brush-radio-button button ]
end

to-report another-brush-radio-button-was-clicked-more-recently [button]
  let first-time-button-was-pressed table:get click-count-when-radio-buttons-were-first-clicked button
  let buttons-pressed-more-recently filter [key -> (key != button) and (table:get click-count-when-radio-buttons-were-first-clicked key > first-time-button-was-pressed)]
    (table:keys click-count-when-radio-buttons-were-first-clicked)
  report not empty? buttons-pressed-more-recently
end

to deselect-brush-radio-button [button]
  table:remove click-count-when-radio-buttons-were-first-clicked button
end

to-report population-properties-initialized? [population]
  report table:has-key? ball-population-properties population
end

to initialize-properties-for-all-populations
  foreach population-numbers [population ->
     table:put ball-population-properties population initialized-population-properties
  ]
end

to-report population-count
  report length table:keys ball-population-properties
end

to initialize-ball-population-properties-old [population]
  let population-color default-color-for-population population
  table:put ball-population-properties population initialized-population-properties
  set-prop population "color" population-color
end

to initialize-ball-population-properties [population]
  table:put ball-population-properties population initialized-population-properties
end

to-report initialized-population-properties
  report table:from-list [
    ["size" 0.5]
    ["shape" "circle"]
    ["heading" "random"]
    ["speed" 10]
    ["color" gray]
    ["name" ""]
    ["secondary-colors" []]
    ["move" false]
    ["wall-heading" "no change"]
    ["wall-speed" "no change"]
    ["ball-heading" "no change"]
    ["ball-speed" "no change"]
    ["other-ball-heading" "no change"]
    ["other-ball-speed" "no change"]
    ["gravity" 0]
    ["electric-field" 0]
  ]
end

to-report amount-of-balls-that-can-be-created-given-maximum-capacity [requested-amount]
  let maximum-amount-of-balls-that-can-currently-be-created (maxballs - count balls)
  report min (list requested-amount maximum-amount-of-balls-that-can-currently-be-created)
end

to notify-user-unable-to-create-balls-due-to-maximum-capacity
  user-message (word "Unable to create more balls, maximum capacity of " maxballs " reached.")
end

to create-balls-if-under-maximum-capacity [population amount -xcor -ycor]
  let amount-of-balls-to-create amount-of-balls-that-can-be-created-given-maximum-capacity amount
  let unable-to-create-balls-due-to-maximum-capacity ifelse-value (amount-of-balls-to-create = 0) and (amount > 0) [true] [false]
  ifelse unable-to-create-balls-due-to-maximum-capacity [
    notify-user-unable-to-create-balls-due-to-maximum-capacity]
  [
    create-balls-at population amount-of-balls-to-create -xcor -ycor
  ]
end

to update-ball-shape
  run shape-update-procedure
end

to reset-sum-of-forces-acting-on-balls
  set force-x-sum 0
  set force-y-sum 0
end

to update-balls-by-population [-ball]
  let population [population-num] of -ball
  table:put balls-by-population population (turtle-set balls-of population -ball)
end

to initialize-ball-after-creation [population -xcor -ycor]
  set population-num population
  set color prop "color"
  set size prop "size"
  update-ball-shape
  set tick-count-move-enabled tick-count
  set speed prop "speed"
  set mass prop "size"
  setxy -xcor -ycor
  update-ball-label
  initialize-ball-heading
  reset-sum-of-forces-acting-on-balls
  update-balls-by-population self
  reset-balls-collided-with
  ;set last-collision nobody
  ;set heading 1000    ; temp value to change below so that only THESE new balls will get new value
  ;set leader self
  ;set stuck-on-wall? false
  ;set wall-hits 0
  ;set momentum-difference 0
end

to update-ball-label
  ifelse show-name [show-ball-label] [hide-ball-label]
end

to hatch-balls-at [population amount -xcor -ycor]
  hatch-balls amount [
    initialize-ball-after-creation population -xcor -ycor
  ]
  on-ball-created
end

to create-balls-at [population amount -xcor -ycor]
  create-balls amount [
    initialize-ball-after-creation population -xcor -ycor
    ifelse amount > 1 [ randomly-move-ball-inside-radius 3 ] [randomly-move-ball-inside-radius 0.1]
  ]
  on-ball-created
end

to randomly-move-ball-inside-radius [radius]
  setxy (xcor + (random-float (radius * 2)) - radius) (ycor + (random-float (radius * 2)) - radius)
end

to on-ball-created
  update-ball-population-plot
  log-command "place-balls"
end

; ball procedure
to initialize-ball-heading
  ifelse prop "heading" = "random" [
    set heading random-float 360 ]
  [
    set heading prop "heading"
  ]
end

to-report population-repels-or-attracts-other-populations? [population]
  let interaction pprop population "other-ball-heading"
  report member? interaction ["repel" "attract" "repel and attract"]
end

;========== getters and setters for ball properties ========

to-report pprop [population property]
  report table:get (properties-of population) property
end

to-report prev-pprop [population property]
  report table:get (prev-properties-of population) property
end

to-report pprop-changed? [population property]
  report pprop population property != prev-pprop population property
end

to-report prop [property] ; ball procedure
  report pprop population-num property
end

to-report is-affected-by-gravity ; ball procedure
  report prop "gravity" > 0
end

to-report properties-of [population]
  report table:get ball-population-properties population
end

to-report prev-properties-of [population]
  report table:get prev-ball-population-properties population
end

to set-prop [population property value]
  table:put (properties-of population) property value
end

;==============================

to-report has-neighbors-with-arrows
  report any? neighbors with [any? arrows-here]
end

to draw-arrow-in-direction-of-electric-field
  ask arrows-here [die]
  ;if ((((round pxcor) mod 2) = 0) and (((round pycor) mod 2) = 0)) [
  if not has-neighbors-with-arrows [
    ;if not has-neighbors-with-arrows and length patches-field-drawn-on mod 4 = 0[
    sprout-arrows 1
    [
      set shape "arrow"
      set color field-color
      set size 1.0
      set heading atan field-x field-y
     ]
  ]
end

to fill-field
  let current-patch []  ; will hold a patch that is being processed

  let list-patches  sort patches with [field-number = field-count  ]   ; list of patches that were marked
  ask (patch-set list-patches) [recolor-patch]
  ask arrows [set color field-color - 4]
  ; fill patches in connected componnent with field-color
  while [not empty? list-patches]
  [ set current-patch first list-patches
    set list-patches but-first list-patches
    ask current-patch
    ;refactor changed "in-radius-nowrap" to "in-radius" since it is not supported in netlogo web
    ;[    ask patches in-radius-nowrap 1 with [ pcolor != wall-color  and pcolor != field-color ]
    [
      ask neighbors4-no-wrap with [(not has-wall) and (not has-field)]
         [
            set field-number field-count
            set list-patches lput self list-patches  ;add to list-patches  ; Another way set frontier2 (patch-set frontier2 patch-here)
            recolor-patch
         ] ; end ask neighbors
    ] ; end ask current-patch
  ] ; end field while

  ; now spread the field vectors in all the painted field cells WITHIN connected comp ONLY
  let list-field-patches []
  let marked-patch []  ;first list-field-marked-patches
  let dist 0

  let list-field-marked-patches  patch-set patches-field-drawn-on ; list of patches that were marked as field by user
  ask  list-field-marked-patches
  [   set marked-patch self
      set list-field-patches  patches with [ field-number = field-count] ; all patches that were colored within same connected comp
      ask list-field-patches
      [
        set dist sqrt ((pxcor - [pxcor] of  marked-patch) ^ 2 + (pycor - [pycor] of  marked-patch) ^ 2 )
;        if dist < max-field-spread  ; spread the field only within a radius
        if (dist = 0) [ set dist (1 / (max-pxcor * 2))]   ; weight is 1/dist and so dist should not be 0
        set accum-w accum-w + (1 / dist)
        set accum-x  accum-x +  ((1 / dist) * [field-x] of marked-patch)
        set accum-y  accum-y +  ((1 / dist) * [field-y] of marked-patch)
;       ] ; end if dist < max-field-spread
    ]
  ]

  ; now compute the final field values of all field patches
  ask list-field-patches
  [  if (accum-w != 0)
     [   set field-x  (accum-x / accum-w)
         set field-y  (accum-y / accum-w)
         ; normalize and set to field strength
         ;set field-x    (field-x / (sqrt ((field-x ^ 2) + (field-y ^ 2)))) * Electric-Field-Strength
         ;set field-y    (field-y / (sqrt ((field-x ^ 2) + (field-y ^ 2)))) * Electric-Field-Strength
         set field-x    (field-x / (sqrt ((field-x ^ 2) + (field-y ^ 2))))
         set field-y    (field-y / (sqrt ((field-x ^ 2) + (field-y ^ 2))))
      ]
  ]

  log-command "fill-field"
end

;patch procedure
to remove-electric-field-from-patch
  ask arrows-here [die]
  set field-number 0
  set field-x  0
  set field-y  0
  set accum-x  0
  set accum-y  0
  set accum-w  0
end

to update-field-count
  set field-count max [field-number] of patches
end

to erase-field [-field-number]
  let patches-occupied-by-field patches with [field-number = -field-number]
  ask patches-occupied-by-field
  [
    remove-electric-field-from-patch
    recolor-patch
  ]
  update-field-count
end

to-report has-field
  report field-number > 0
end

to-report field-exists
  report field-count > 0
end

to recolor-patch
  (ifelse
    has-wall [set pcolor wall-color ]
    has-field [set pcolor field-color ]
    [set pcolor current-background-color] )
end

to paint-world
  set current-background-color background-color
  recolor-all-patches
  log-command "paint-world"
end

to recolor-all-patches
  ask patches [recolor-patch]
end

to-report interaction-clause-of-population [population]
  report child-by-name table:get ast-by-population population "interactions"
end

to netlogo-web-advance-balls-in-world
    ask balls [
      run-interactions-clause (interaction-clause-of-population population-num) population-num
      factor-forces-acting-on-ball
      set-ball-speed-to-maximum-if-above-max-speed
      reset-balls-collided-with
    ]
    ask balls [
      move
    ]
end

to factor-forces-acting-on-ball
  apply-forces-acting-on-ball
  reset-sum-of-forces-acting-on-balls
end

to advance-balls-in-world2
  netlogo-web-advance-balls-in-world
end

to advance-balls-in-world
  ifelse netlogo-web? [
    netlogo-web-advance-balls-in-world ]
  [
    ask balls [
      factor-electric-field ; add change of speed and heading due to electric field
      factor-repel-and-attract-forces
      factor-gravity;
      check-for-wall-collision
      check-for-ball-collision
      set-ball-speed-to-maximum-if-above-max-speed
      reset-balls-collided-with
    ]
    ask balls [
      move
    ]
  ]
end

to reset-balls-collided-with
  set balls-collided-with no-turtles
end

to remove-flashes-past-their-lifespan
  ask flashes with [tick-count - birthday > flash-time] [die]
end

to run-animations
  ask animations [run animate]
end

to-report any-moving-balls?
  let any-ball-moving false
  ask balls [if ball-can-move [set any-ball-moving true stop]]
  report any-ball-moving;
end

to-report atleast-n-ticks-have-passed-since-last-display-update [n]
  report tick-count - last-tick-count-display-was-updated >= n
end

to update-display-every-n-ticks [n]
  if atleast-n-ticks-have-passed-since-last-display-update n [
    update-display]
end

to update-display
  display
  ;no-display
  set last-tick-count-display-was-updated tick-count
end

to advance-ticks
  tick-advance tick-advance-amount
  set tick-count tick-count + 1
end

to log-go-procedure
  if (test-if-log-output "play" = TRUE) [  ; test that prev logging is not exactly the same
    log-output "play"
    log_picture
  ]
end

to re-enable-movement-for-balls-predefined-to-move-limited-number-of-ticks
  ask balls with [is-number? prop "move"] [set tick-count-move-enabled tick-count]
end

;============= ast parse ====================

to-report map-population-names-to-populaiton-number
  let mapped-population-names table:make
  foreach population-numbers [population-number -> table:put mapped-population-names (pprop population-number "name") population-number]
  report mapped-population-names
end

to-report convert-to-number-if-possible [input]
  let output input
  carefully [
    set output read-from-string input
  ] []
  report output
end

to-report user-population-input-to-population-number [raw-input]
  let population-input convert-to-number-if-possible raw-input
  let mapped-population-names map-population-names-to-populaiton-number
  let population-names table:keys mapped-population-names
  let input-is-population-number member? population-input population-numbers
  let input-is-population-name member? population-input population-names
  (ifelse
    input-is-population-number [report population-input]
    input-is-population-name [report table:get mapped-population-names population-input]
  )
  report false
end

to-report is-multiple-objects [objects]
  report length objects > 1
end

to apply-heading-change-if-meets-with-ball [other-balls heading-change]
  (ifelse
    heading-change = "no change" []
    heading-change = "collide" [change-heading-if-collides-with other-balls heading-change]
    heading-change = "turn left" [change-heading-if-collides-with other-balls heading-change]
    heading-change = "turn right" [change-heading-if-collides-with other-balls heading-change]
    heading-change = "repel" [apply-force-on other-balls heading-change]
    heading-change = "attract" [apply-force-on other-balls heading-change]
    heading-change = "repel and attract" [apply-force-on other-balls heading-change]
  )
end

to apply-speed-change-if-meets-with-ball [other-balls speed-change]
  (ifelse
    speed-change = "zero" [change-speed-if-collides-with other-balls speed-change]
    speed-change = "increase" [change-speed-if-collides-with other-balls speed-change]
    speed-change = "decrease" [change-speed-if-collides-with other-balls speed-change]
  )
end

to-report random-chance [probability]
  let normalized-probability probability / 100
  report random-float 1 < normalized-probability
end

to-report object-is-balls [object]
  report is-turtle-set? object
end

to-report objects-colliding-with [objects]
  report ifelse-value is-multiple-objects objects [objects-colliding-with-multiple-objects objects] [objects-colliding-with-single-object objects]
end

to-report objects-colliding-with-multiple-objects [objects]
  ifelse multiple-objects-already-set objects [
    report ifelse-value count ((turtle-set objects) with [ball-collides-with myself]) = length objects [objects] [false] ]
  [
    let all-balls-in-collision balls-colliding
    let ball-populations objects
    let balls-in-collision [] ; a single combination set (of all possible) from balls in radius
    ask all-balls-in-collision [
      if member? population-num ball-populations [
        set ball-populations remove-item (position population-num ball-populations) ball-populations
        set balls-in-collision lput self balls-in-collision
        if empty? ball-populations [stop]
      ]
    ]
    report ifelse-value empty? ball-populations [balls-in-collision] [false]
  ]
end

to-report objects-colliding-with-single-object [objects]
  let -objects-colliding balls-colliding-from (first objects)
  report ifelse-value any? -objects-colliding [(list -objects-colliding)] [false]
end

to-report objects-in-radius [objects radius]
  report ifelse-value is-multiple-objects objects [objects-in-radius-multiple-objects objects radius] [objects-in-radius-single-object objects radius]
end

to-report parse-function-of [node]
  let a table:get-or-default ast-lookup-table-parse-node node-name node false
  if a = false [error (word "can not find parse function for " node)]
  report table:get ast-lookup-table-parse-node node-name node
end

to-report run-function-of [node]
  report table:get ast-lookup-table-run-node node-name node
end

to-report parse-result-of-node [node population objects]
  report (runresult (parse-function-of node) node population objects)
end

to-report run-result-of-node [node population objects]
  report (runresult (run-function-of node) node population objects)
end

to parse-node [node population objects]
  (run (parse-function-of node) node population objects)
end

to run-node [node population objects]
  (run (run-function-of node) node population objects)
end

to-report parse-result-children [node population objects]
  report map [child -> parse-result-of-node child population objects] node-children node
end

to parse-children [node population objects]
  foreach node-children node [child -> parse-node child population objects]
end

to-report run-result-children [node population objects]
  report map [child -> run-result-of-node child population objects] node-children node
end

to run-children [node population objects]
  foreach node-children node [child -> run-node child population objects]
end

to parse-heading-block [node population objects]
  let parameters node-parameters node
  let heading-change table:get parameters "heading"
  ifelse not is-multiple-objects objects [
    let object first objects
    if not member? object ["wall" "ball-same-population" "ball-from-population"] [
      let message (word "Heading can not be set for '" object "'" )
      throw-ast-error node message
    ]
    if member? heading-change ["repel" "attract" "repel and attract"] and not member? object ["ball-same-population" "ball-from-population"] [
      let message (word "Heading '" heading-change "' can not be set for '" object "'" )
      throw-ast-error node message
    ]
  ]
  [
    let message (word "Heading can not be set for multiple objects: " objects )
    throw-ast-error node message
  ]
end

to run-heading-block [node population objects]
  let parameters node-parameters node
  let heading-change table:get parameters "heading"
  let object first objects
  (ifelse
    object = "wall" [change-heading-if-collides-with-wall heading-change]
    object-is-balls object [apply-heading-change-if-meets-with-ball object heading-change]
  )
end

to parse-speed-block [node population objects]
  let parameters node-parameters node
  let speed-change table:get parameters "speed"
  let object first objects
  ifelse not is-multiple-objects objects [
    if not member? object ["wall" "ball-same-population" "ball-from-population"] [
      let message (word "Speed can not be set for '" object "'" )
      throw-ast-error node message
    ]
    if member? speed-change ["repel" "attract" "repel and attract"] and not member? object ["ball-same-population" "ball-from-population"] [
      let message (word "Speed '" speed-change "' can not be set for '" object "'" )
      throw-ast-error node message
    ]
  ]
  [
    let message (word "Speed can not be set for multiple objects: " objects )
    throw-ast-error node message
  ]
end

to run-speed-block [node population objects]
  let parameters node-parameters node
  let speed-change table:get parameters "speed"
  let object first objects
  (ifelse
    object = "wall" [change-speed-if-collides-with-wall speed-change]
    object-is-balls object [apply-speed-change-if-meets-with-ball object speed-change ]
  )
end

to parse-field-strength-block [node population objects]
  let object first objects
  if not member? object ["gravity-field" "electric-field"] [
    let message (word "field strength can not be set for " object )
    throw-ast-error node message
  ]
end

to run-field-strength-block [node population objects]
  let parameters node-parameters node
  let field-strength table:get parameters "strength"
  let object first objects
  (ifelse
    object = "gravity-field" [apply-gravity (- field-strength)]
    object = "electric-field" [apply-electric-field field-strength]
  )
end

to parse-create-balls-block [node population]
  let name node-name node
  let parameters node-parameters node
  let user-defined-population table:get parameters "population"
  let population-of-ball-being-created user-population-input-to-population-number user-defined-population
  if population-of-ball-being-created = false [
    let message (word "Population '" user-defined-population "' defined in '" name "' block does not exist.")
    throw-ast-error node message
  ]
end

to run-create-balls-block [node population]
  let name node-name node
  let parameters node-parameters node
  let amount table:get parameters "amount"
  let user-defined-population table:get parameters "population"
  let population-of-ball-being-created user-population-input-to-population-number user-defined-population
  hatch-balls-at population-of-ball-being-created amount xcor ycor
end

to-report center-xy [agent-set]
  report (list mean [xcor] of agent-set mean [ycor] of agent-set)
end

to extend-mark-lifespan [mark]
  ask mark [set birthday tick-count]
end

to set-mark-xy [mark x y]
  ask mark [setxy x y]
end

to set-mark-size [mark -size]
  ask mark [set size -size]
end

to-report create-mark [x y -size -color -shape -lifespan]
  let mark-created nobody
  hatch-animations 1 [
    set -name "mark"
    setxy x y
    set shape -shape
    set color add-transparency -color 0.35
    set size -size
    set label ""
    set label-color white
    set heading 0
    show-turtle
    set birthday tick-count
    set data table:from-list (list (list "lifespan" -lifespan))
    set animate [[] -> remove-animation-if-past-lifespan]
    set mark-created self
  ]
  report mark-created
end

to remove-animation-if-past-lifespan
  let lifespan table:get data "lifespan"
  if tick-count - birthday > lifespan [die]
end

to rotate-animation
  ; Need to find a way to chain animatin procedures, such as
  ; chain-animation (list rotate-animation remove-animation-if-past-lifespan)
  set heading heading + table:get data "angle"
  remove-animation-if-past-lifespan
end

to increase-animation-size
  let increase table:get data "increase"
  set size size * ((100 + increase) / 100)
  remove-animation-if-past-lifespan
end

to flash-animation
  let flash-rate table:get data "flash-every-n-ticks"
  let should-change-color tick-count mod flash-rate = 0
  if should-change-color [
    let is-flashing table:get data "is-flashing"
    let next-color ifelse-value is-flashing [table:get data "original-color"] [table:get data "flash-color"]
    table:put data "is-flashing" not is-flashing
    set color next-color
  ]
  remove-animation-if-past-lifespan
end

to-report animation-data-by-name [effect -shape -color -lifespan]
  ; Should be a global variable for animation data lookup.
  (ifelse
    effect = "rotate" [report table:from-list [["angle" 10]]]
    effect = "flash" [report table:from-list (list
      (list "flash-every-n-ticks" 2)
      (list "is-flashing" false)
      (list "original-color" -color)
      (list "flash-color" set-color-brightness -color 1))]
    effect = "inflate" [report table:from-list [["increase" 5]]]
  )
end

to run-animate-block [node population objects]
  let parameters node-parameters node
  let -shape table:get parameters "shape"
  let -lifespan table:get parameters "lifespan"
  let -effect table:get parameters "effect"
  let -size table:get parameters "size"
  let -color add-transparency table:get parameters "color" 0.35
  let -data animation-data-by-name -effect -shape -color -lifespan
  table:put -data "lifespan" -lifespan
  let -animate animation-by-name -name
  hatch-animation -effect -shape -color -size -data -animate
end

to hatch-animation [name -shape -color -size -data -animate]
  hatch-animations 1 [initialize-animation name -shape -color -size -data -animate]
end

to-report create-animation [name -shape -color -size -data -animate]
  let created-animation nobody
  create-animations 1 [
    initialize-animation name -shape -color -size -data -animate
    set created-animation self
  ]
  report created-animation
end

to initialize-animate-anonymous-procedure
  set animate animation-by-name -name
end

to initialize-animation [name -shape -color -size -data -animate]
  set -name name
  set shape -shape
  set color -color
  set size -size
  set label ""
  set label-color white
  set heading 0
  show-turtle
  set birthday tick-count
  set data -data
  set animate animation-by-name name
end

to parse-animate-block [node population objects]
  ; check if lifespan is negative
end

to run-draw-block [node population objects]
  let parameters node-parameters node
  let -shape table:get parameters "shape"
  let -lifespan table:get parameters "lifespan"
  let -color table:get parameters "color"
  let -size table:get parameters "size"
  hatch-animations 1 [
    set -name "draw"
    set shape -shape
    set color add-transparency -color 0.35
    set size -size
    set label ""
    set label-color white
    set heading 0
    show-turtle
    set birthday tick-count
    set data table:from-list (list (list "lifespan" -lifespan))
    set animate [[] -> remove-animation-if-past-lifespan]
  ]
end

to parse-draw-block [node population objects]
  ; check if lifespan is negative
end

to run-mark-block [node population objects]
  let balls-to-mark (turtle-set self ifelse-value is-multiple-objects objects [objects] [one-of first objects])
  let parameters node-parameters node
  let mark-shape table:get parameters "shape"
  let mark-lifespan table:get parameters "lifespan"
  let mark-color table:get parameters "color"
  let mark-center center-xy balls-to-mark
  let mark-xcor first mark-center
  let mark-ycor last mark-center
  let mark-radius max [(distancexy mark-xcor mark-ycor) + size + 1.5] of balls-to-mark
  let my-mark table:get-or-default node who nobody
  ifelse my-mark = nobody [
    table:put node who create-mark mark-xcor mark-ycor mark-radius mark-color mark-shape mark-lifespan
  ]
  [
    ask my-mark [
      setxy mark-xcor mark-ycor
      set size mark-radius
    ]
    extend-mark-lifespan my-mark
  ]
end

to parse-mark-block [node population objects]
  validate-has-one-of-ancestors node ["if-collide" "if-in-radius"]
  ; check if lifespan negative
end

to run-repeat-block [node population objects]
  let parameters node-parameters node
  let amount table:get parameters "amount"
  repeat amount [run-children node population objects]
end

to parse-repeat-block [node population objects]
  let parameters node-parameters node
  let amount table:get parameters "amount"
  if amount < 0 [
    let message (word "Repeat amount can not be negative: " amount)
    throw-ast-error node message
  ]
  parse-children node population objects
end

to parse-disappear-block [node population objects]
  let name node-name node
  let parameters node-parameters node
  let user-defined-population table:get parameters "population"
  let population-of-ball-being-created user-population-input-to-population-number user-defined-population
  if population-of-ball-being-created = false [
    let message (word "Population '" user-defined-population "' defined in '" name "' block does not exist.")
    throw-ast-error node message
  ]
end

to run-disappear-block [node population objects]
  let name node-name node
  let parameters node-parameters node
  let user-defined-population table:get parameters "population"
  let population-of-ball-being-removed user-population-input-to-population-number user-defined-population
  let removal-candidates (turtle-set objects) with [population-num = population-of-ball-being-removed]
  ifelse any? removal-candidates [
    ask one-of removal-candidates [remove-ball]]
  [
    if population-num = population-of-ball-being-removed [remove-ball]
  ]
end

to parse-add-block [node population]
  let name node-name node
  let parameters node-parameters node
  let user-defined-population table:get parameters "population"
  let population-of-ball-being-created user-population-input-to-population-number user-defined-population
  if population-of-ball-being-created = false [
    let message (word "Population '" user-defined-population "' defined in '" name "' block does not exist.")
    throw-ast-error node message
  ]
end

to run-add-block [node population]
  let name node-name node
  let parameters node-parameters node
  let user-defined-population table:get parameters "population"
  let population-of-ball-being-created user-population-input-to-population-number user-defined-population
  hatch-balls-at population-of-ball-being-created 1 xcor ycor
end

to parse-at-least-x-ticks-block [node population objects]
  let name node-name node
  let parameters node-parameters node
  let amount table:get parameters "amount"
  if amount < 0 [
    let message (word "Tick amount can not be negative: " amount)
    throw-ast-error node message
  ]
  parse-children node population objects
end

to run-at-least-x-ticks-block [node population objects]
  let parameters node-parameters node
  let amount table:get parameters "amount"
  table:put node who last-n-elements (sentence (table:get-or-default node who []) tick-count) amount
  let arithmetic-sum (amount * (amount + 1)) / 2
  let sum-tick-count-of-last-x-visits-here sum table:get node who
  let has-visited-node-x-consequtive-ticks (sum-tick-count-of-last-x-visits-here + arithmetic-sum) = (tick-count + 1) * amount
  if has-visited-node-x-consequtive-ticks [
    run-children node population objects
  ]
end

to run-chance-block [node population objects]
  let probability table:get node-parameters node "probability"
  if random-chance probability [run-children node population objects]
end

to parse-chance-block [node population objects]
  validate-node-has-only-children-named node ["heading" "speed" "field-strength" "create-ball" "chance" "kill-balls-that-meet" "if-collide" "if-in-radius" "add" "disappear" "repeat" "mark" "at-least-x-ticks"]
  parse-children node population objects
end

to parse-if-in-radius-block [node population objects]
  validate-node-has-only-children-named node ["heading" "speed" "chance" "create-ball" "kill-balls-that-meet" "if-collide" "if-in-radius" "add" "disappear" "repeat" "mark" "at-least-x-ticks"]
  parse-children node population objects
end

to run-if-in-radius-block [node population objects]
  let parameters node-parameters node
  let radius table:get parameters "radius"
  let -objects-in-radius objects-in-radius objects radius
  if -objects-in-radius != false [run-children node population -objects-in-radius]
end

to parse-if-collide-block [node population objects]
  validate-node-has-only-children-named node ["heading" "speed" "chance" "create-ball" "kill-balls-that-meet" "if-collide" "if-in-radius" "add" "disappear" "repeat" "mark" "at-least-x-ticks"]
  parse-children node population objects
end

to run-if-collide-block [node population objects]
  let -objects-colliding-with objects-colliding-with objects
  if -objects-colliding-with != false [run-children node population -objects-colliding-with]
end

to parse-if-ball-meets-block-then-clause [node population objects]
  validate-node-has-only-children-named node ["heading" "speed" "field-strength" "chance" "create-ball" "kill-balls-that-meet" "if-collide" "if-in-radius" "add" "disappear" "repeat" "mark" "at-least-x-ticks"]
  let name node-name node
  let children node-children node
  if (empty? objects) and (not empty? children) [
    let message (word "No objects defined" )
    throw-ast-error node message
  ]
  parse-children node population objects
end

to run-if-ball-meets-block-then-clause [node population objects]
  run-children node population objects
end

to parse-kill-balls-that-meet-block [node population objects]
  validate-has-one-of-ancestors node ["if-collide" "if-in-radius"]
end

to run-kill-balls-that-meet-block [node population objects]
  ifelse is-multiple-objects objects [foreach [self] of turtle-set objects remove-ball] [ask one-of turtle-set objects [remove-ball]]
  remove-ball
end

to parse-if-ball-meets-block [node population]
  let children node-children node
  let children-names map node-name children
  let objects-clause child-by-name node "objects"
  let then-clause child-by-name node "then"
  let objects parse-result-of-node objects-clause population []
  parse-node then-clause population objects
end

to run-if-ball-meets-block [node population]
  let children node-children node
  let objects-clause child-by-name node "objects"
  let then-clause child-by-name node "then"
  let objects run-result-of-node objects-clause population []
  run-node then-clause population objects
end

to-report run-wall-block [node population]
  report "wall"
end

to parse-wall-block [node population]
  ; nothing to parse
end

to-report run-ball-same-population-block [node population]
  ;report (list "ball" population)
  report population
end

to parse-ball-same-population-block [node population]
  ; nothing to parse
end

to-report run-ball-other-population-block [node population]
  let name node-name node
  let parameters node-parameters node
  let user-defined-population table:get parameters "population"
  let other-population user-population-input-to-population-number user-defined-population
  report other-population
end

to parse-ball-other-population-block [node population]
  let name node-name node
  let parameters node-parameters node
  let user-defined-population table:get parameters "population"
  let other-population user-population-input-to-population-number user-defined-population
  if other-population = false [
    let message (word "Population '" user-defined-population "' defined in '" name "' block does not exist.")
    throw-ast-error node message
  ]
end

to-report run-gravity-field-block [node population]
  report "gravity-field"
end

to parse-gravity-field-block [node population]
  ; nothing to parse
end

to-report run-electric-field-block [node population]
  report "electric-field"
end

to parse-electric-field-block [node population]
  ; nothing to parse
end

to-report parse-if-ball-meets-block-objects-clause [node population]
  validate-node-has-only-children-named node ["wall" "ball-same-population" "ball-from-population" "gravity-field" "electric-field"]
  let children node-children node
  let objects map node-name children
  let non-ball-objects filter [object -> not member? object ["ball-same-population" "ball-from-population"]] objects
  let objects-contain-non-ball-object not empty? non-ball-objects
  if (length children > 1) and (objects-contain-non-ball-object) [
    let message (word "Multiple objects is only defined for ball type objects, please remove the following: "
      non-ball-objects " from objects: " objects)
    throw-ast-error node message
  ]
  parse-children node population []
  report objects
end

to-report objects-clause-has-multiple-ball-objects [node]
  let children-names map node-name node-children node
  report not empty? filter [name -> member? name ["ball-same-population" "ball-from-population"]] children-names
end

to-report run-if-ball-meets-block-objects-clause [node population]
  let objects run-result-children node population []
  ; only balls can be multiple objects, if so then handle what their values should be.
  ; if single object then return agent-set of balls
  ; if multiple objects then return population-numbers of balls in a list as is
  ; if multiple objects and has gone through a block that changes object then return list of turtles (not done in this function)
  if objects-clause-has-multiple-ball-objects node [
    report ifelse-value is-multiple-objects objects [objects] [map [object -> other balls-of object] objects] ]
  report objects
end

to parse-actions-and-properties-of-configure-population-block [node]
  let parameters node-parameters node
  let population table:get parameters "population"
  let properties-clause child-by-name node "properties"
  let actions-clause child-by-name node "actions"
  parse-properties-clause properties-clause population
  parse-actions-clause actions-clause population
end

to run-actions-and-properties-of-configure-population-block [node]
  let parameters node-parameters node
  let population table:get parameters "population"
  initialize-ball-population-properties population
  let properties-clause child-by-name node "properties"
  let actions-clause child-by-name node "actions"
  run-properties-clause properties-clause population
  run-actions-clause actions-clause population
end

to parse-interactions-clause [node population]
  validate-node-has-only-children-named node ["if-ball-meets"]
  parse-children node population []
end

to run-interactions-clause [node population]
  run-children node population []
end

to parse-actions-clause [node population]
  validate-node-has-only-children-named node ["move-forever" "move-x-steps"]
  validate-only-one-of-children-exists node ["move-forever" "move-x-steps"]
  validate-no-duplicate-children-named node ["move-forever" "move-x-steps"]
  parse-children node population []
end

to run-actions-clause [node population]
  run-children node population []
end

to parse-move-forever-block [node population]
  ; nothing to parse
end

to run-move-forever-block [node population]
  set-prop population "move" true
end

to parse-move-x-steps-block [node population]
  ; nothing to parse
end

to run-move-x-steps-block [node population]
  let parameters node-parameters node
  let steps table:get parameters "steps"
  set-prop population "move" steps
end

to parse-properties-clause [node population]
  validate-node-has-only-children-named node ["color" "size" "shape" "initial-heading" "initial-speed" "name"]
  parse-children node population []
end

to run-properties-clause [node population]
  run-children node population []
end

to parse-property-block [node population]
  ; nothing to currently parse in general property block
end

to run-property-block [node population]
  let parameters node-parameters node
  let property-name first table:keys parameters
  let property-value table:get parameters property-name
  set-prop population property-name property-value
end

to parse-color-block [node population]
  ; nothing to currently parse in color block
end

to run-color-block [node population]
  let color-value node-parameter node "color"
  ifelse is-first-color-property-to-be-defined node [
    set-prop population "color" color-value]
  [
    add-secondary-color-to-population population color-value
  ]
end

to add-secondary-color-to-population [population -color]
  set-prop population "secondary-colors" lput -color pprop population "secondary-colors"
end

to-report is-first-color-property-to-be-defined [node]
  let parent node-parent node
  let sibling-nodes node-children parent
  let node-index position node sibling-nodes
  report empty? filter [sibling-node -> node-name sibling-node = "color"] sublist sibling-nodes 0 node-index
end

to-report multiple-objects-already-set [objects]
  report is-turtle? one-of objects
end

to-report objects-in-radius-multiple-objects [objects radius]
  ifelse multiple-objects-already-set objects [
    report ifelse-value count (turtle-set objects in-radius radius) = length objects [objects] [false]
  ] [
    let all-balls-in-radius other (balls in-radius radius)
    let ball-populations objects
    let balls-in-radius [] ; a single combination set (of all possible) from balls in radius
    ask all-balls-in-radius [
      if member? population-num ball-populations [
        set ball-populations remove-item (position population-num ball-populations) ball-populations
        set balls-in-radius lput self balls-in-radius
        if empty? ball-populations [stop]
      ]
    ]
    report ifelse-value empty? ball-populations [balls-in-radius] [false]
  ]
end

to-report objects-in-radius-single-object [objects radius]
  let -objects-in-radius (first objects) in-radius radius
  report ifelse-value any? -objects-in-radius [(list -objects-in-radius)] [false]
end

to update-shapes-of-population [population]
  ask balls-of population [update-ball-shape]
end

to update-color-of-population [population]
  ask balls-of population [update-ball-color]
end

to update-size-of-population [population]
  ask balls-of population [update-ball-size]
end

to update-ball-size
  set size prop "size"
  ; compound shapes need to be updated to new size as well
  update-ball-shape
end

to update-ball-color
  set color prop "color"
  ; compound shapes need to be updated to new color as well
  update-ball-shape
end

to-report unequal-keys [table1 table2]
  report filter [key -> table:get table1 key != table:get table2 key] table:keys table1
end

to-report properties-that-changed-for-population [population]
  report unequal-keys (properties-of population) (prev-properties-of population)
end

to notify-property-changed-for-population [population property]
  (run property-changed-procedure property population)
end

to-report property-changed-procedure [property]
  report table:get-or-default property-change-procedure-lookup property [[population] -> ]
end

to-report global-variable-changed-procedure [global-variable]
  report table:get-or-default global-variable-changed-lookup global-variable [[new-value] -> ]
end

to-report global-variables-that-changed
  let current global-variable-values
  let prev prev-global-variable-values
  let changed-values table:from-list map [global-variable -> (list global-variable table:get current global-variable)] (unequal-keys prev current)
  set prev-global-variable-values current
  report changed-values
end

to notify-of-global-variable-changes
  let changed-global-variables global-variables-that-changed
  foreach table:keys changed-global-variables [global-variable ->
    let new-value table:get changed-global-variables global-variable
    (run global-variable-changed-procedure global-variable new-value) ]
end

to notify-properties-that-changed-for-population [population]
  foreach properties-that-changed-for-population population [
    changed-property -> notify-property-changed-for-population population changed-property ]
end

to notify-properties-that-changed-for-each-population
  foreach population-numbers notify-properties-that-changed-for-population
end

to update-ball-population-properties-defined-in-nettango-blocks
  ; in order to account for changes to property blocks, every turn the population properties are initialized
  ; and reset. The reason is that if a block is removed, then the option for that property must
  ; be set to default, which is done by initializing all population properties and reapplying
  ; properties of remaining blocks.
  ; these functions are defined in nettango, so to reduce the amount of lines
  ; needed to be changed between desktop and web use, the primitive "run"
  ; is used because the compiler can not check if these procedures exist until runtime
  initialize-all-lookup-tables-if-nettango-has-recompiled
  set nodes-by-id []
  set id-counter 0

  let amount-of-populations 3
  foreach (range 1 (amount-of-populations + 1)) [ population ->
    run (word "configure-population-" population)
  ]
  keep-prev-ast-if-new-ast-did-not-change
  ;todo parsing is redundant if ast has not changed
  ;need to run actions here
  foreach (range 1 (amount-of-populations + 1)) [ population ->
    parse-actions-and-properties-of-configure-population-block table:get ast-by-population population
  ]
  foreach (range 1 (amount-of-populations + 1)) [ population ->
    run-actions-and-properties-of-configure-population-block table:get ast-by-population population
  ]
  foreach (range 1 (amount-of-populations + 1)) [ population ->
    parse-interactions-clause interaction-clause-of-population population population
  ]
  notify-properties-that-changed-for-each-population
end

to keep-prev-ast-if-new-ast-did-not-change
  if not tables-are-equal curr-ast-by-population prev-ast-by-population  [
    set ast-by-population copy-table curr-ast-by-population
    set last-used-nodes-by-id nodes-by-id
  ]
  set prev-ast-by-population table-as-list curr-ast-by-population
  set curr-ast-by-population table:make
  ; this line of code is important, since every tick a new ast is formed, and
  ; nodes-by-id gets updated with the new nodes, however it needs to get set to
  ; the list of nodes that the current running ast is using, which is not the same
  ; as the ast the was just formed in nettango. The nodes need this to know how to
  ; refer to each other by id.
  ; TODO: find a more elegant solution.
  set nodes-by-id last-used-nodes-by-id
end

to time-run
  ;if tick-count = 0 [profiler:reset profiler:start]
  ;if tick-count = 500 [print profiler:report profiler:reset]
end


to go
  time-run
  log-go-procedure
  ;update-ball-population-properties-defined-in-nettango-blocks
  if netlogo-web? [
    update-ball-population-properties-defined-in-nettango-blocks ]
  ifelse any-moving-balls? [
    every (tick-advance-amount) [
      advance-balls-in-world
      remove-flashes-past-their-lifespan
      run-animations
      advance-ticks
      update-all-plots
      update-display-every-n-ticks 2
    ]
  ][
    re-enable-movement-for-balls-predefined-to-move-limited-number-of-ticks
    on-end-of-turn
    stop  ; unselect "play" button
  ]
  on-end-of-turn
end

to on-end-of-turn
  set brush-activated-after-model-was-advanced false
  set prev-ball-population-properties copy-table ball-population-properties
  notify-of-global-variable-changes
  check-if-should-color-balls-relative-to-population-speed
end

to-report prev-global-variable [name]
  report table:get prev-global-variable-values name
end

to check-if-should-color-balls-relative-to-population-speed
  if color-speed [color-balls-relative-to-population-speed]
end

to show-balls-labels
  ask balls [show-ball-label]
end

to hide-balls-labels
  ask balls [hide-ball-label]
end

to update-ball-labels
  ifelse show-name [
    show-balls-labels ]
  [
    hide-balls-labels
  ]
end

to color-population-by-speed [population]
  let -balls balls-of population
  if (count -balls > 1) [
    let speed-of-balls [speed] of -balls
    let average-speed mean speed-of-balls
    let speed-standard-deviation standard-deviation speed-of-balls
    let lower-limit average-speed - 3 * speed-standard-deviation
    let upper-limit average-speed + 3 * speed-standard-deviation
    ask -balls [set color scale-color color speed (lower-limit - 1) (upper-limit + 1)]
  ]
end

to color-balls-relative-to-population-speed
  foreach population-numbers [population -> color-population-by-speed population]
end

to show-ball-label
  set label prop "name"
  set label-color white
end

to hide-ball-label
  set label-color add-transparency label-color 0
end

; ball procedure
to-report ball-can-move
  let -move-forward prop "move"
  report ifelse-value is-boolean? -move-forward [-move-forward] [tick-count - tick-count-move-enabled < -move-forward]
end

; turtle procedure
to flash-counter-here
  if [has-counter] of patch-here [
    ask patch-here [flash-patch black] ]
end

; patch procedure
to-report has-flash
  report any? flashes-here
end

; patch procedure
to create-flash-here [-flash-color]
  sprout-flashes 1 [
    set color -flash-color
    set birthday tick-count
    set heading 0
  ]
end

; patch procedure
to flash-patch [-flash-color]
  ifelse has-flash [
    renew-lifespan-of-flash-here ]
  [
    create-flash-here -flash-color
  ]
end

; patch procedure
to renew-lifespan-of-flash-here
  ask one-of flashes-here [set birthday ticks]
end

to set-ball-xy-to-return-cyclically-around-world
  set xcor (((xcor + max-pxcor) mod (2 * max-pxcor)) - max-pxcor)
  set ycor (((ycor + max-pycor) mod (2 * max-pycor)) - max-pycor)
end

to-report is-ball-being-traced
  report pen-mode = "down"
end

to return-ball-cyclically-around-world
  ifelse is-ball-being-traced [
    pen-up
    set-ball-xy-to-return-cyclically-around-world
    pen-down ]
  [
    set-ball-xy-to-return-cyclically-around-world
  ]
end

; ball procedure
to-report move-distance
  report (speed * tick-advance-amount)
end

to-report edge-patches-with-electric-field-like-mine
  report edge-patches with [field-number = [field-number] of myself]
end

to-report edge-patches
  report (patch-set
    n-values (world-width) [x -> (patch-set (patch (min-pxcor + x) max-pycor) (patch (min-pxcor + x) min-pycor))]
    n-values (world-height) [y -> (patch-set (patch max-pxcor (min-pycor + y)) (patch min-pxcor (min-pycor + y)))]
    )
end

to-report ball-is-in-electric-field
  report has-electric-field
end

to-report neighbors-no-wrap
  report neighbors with [is-neighbor-no-wrap myself]
end

to-report neighbors4-no-wrap
  report neighbors4 with [is-neighbor-no-wrap myself]
end

to-report is-neighbor-no-wrap [-patch]
  let abs-xcor-delta abs (pxcor - [pxcor] of -patch)
  let abs-ycor-delta abs (pycor - [pycor] of -patch)
  report (abs-xcor-delta <= 1) and (abs-ycor-delta <= 1) and (self != -patch)
end

to-report is-moving-past-edge-of-world
  let patch-ball-will-move-to destination-patch-if-ball-were-to-move
  let ball-will-move-to-new-patch patch-ball-will-move-to != patch-here
  report (ball-will-move-to-new-patch) and (not [is-neighbor-no-wrap patch-ball-will-move-to] of patch-here)
end

to-report destination-patch-if-ball-were-to-move
  report patch-ahead move-distance
end

to-report is-ball-exiting-world-through-electric-field
  report ball-is-in-electric-field and is-moving-past-edge-of-world
end

to move-ball-to-random-edge-patch-with-same-electric-field-it-is-currently-on
  let patches-on-edge edge-patches-with-electric-field-like-mine
  let new-patch one-of patches-on-edge   ;
  set xcor  [pxcor] of new-patch
  set ycor  [pycor] of new-patch
  if (([field-x] of new-patch != 0) or ([field-y] of new-patch != 0)) [
    set heading atan [field-x] of new-patch  [field-y] of new-patch ]
end

to move
  if ball-can-move [
    if is-ball-exiting-world-through-electric-field [
      move-ball-to-random-edge-patch-with-same-electric-field-it-is-currently-on ]
    jump move-distance
    on-ball-moved
  ]
end

to on-ball-moved
  increase-counter-on-patch-ball-is-on
end

to increase-counter-on-patch-ball-is-on
  if any? counters-here [
    increase-counter counter-number-here
    flash-counter-here
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;bounce;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report heading-quadrant
  let -heading heading mod 360
  (ifelse
    (-heading >= 0) and (-heading < 90) [report 1]
    (-heading >= 90) and (-heading < 180) [report 2]
    (-heading >= 180) and (-heading < 270) [report 3]
    (-heading >= 270) and (-heading < 360) [report 4]
  )
end

to-report check-wall-collision-quadrant-1
 let new-patch patch-ahead lookAhead
 if new-patch = nobody [report false]
 let new-patch-right  patch-at-heading-and-distance  90 lookAhead
 let new-patch-up    patch-at-heading-and-distance    0 lookAhead
 if (new-patch-right = nobody) [set new-patch-right patch-here]  ; if at edge of world
 if (new-patch-up = nobody) [set new-patch-up patch-here]  ; if at edge of world

 (ifelse
   (([has-wall] of new-patch-right) and ([has-wall] of new-patch-up) ) [report (list "corner" [pxcor] of new-patch-right [pycor] of new-patch-right)]
   ([has-wall] of new-patch-right)   [report (list "right" [pxcor] of new-patch-right [pycor] of new-patch-right)]
   ([has-wall] of new-patch-up)     [report (list "up" [pxcor] of new-patch-up [pycor] of new-patch-up)]
   ([has-wall] of new-patch)        [report (list "corner" [pxcor] of new-patch [pycor] of new-patch)]
    [report false]
 )
end

to-report check-wall-collision-quadrant-2
  let new-patch patch-ahead lookAhead
  if new-patch = nobody [report false]
  let new-patch-right  patch-at-heading-and-distance   90 lookAhead
  let new-patch-down  patch-at-heading-and-distance  180 lookAhead
  if (new-patch-right = nobody) [set new-patch-right patch-here]  ; if at edge of world
  if (new-patch-down = nobody) [set new-patch-down patch-here]  ; if at edge of world

  (ifelse
    (([has-wall] of new-patch-right) and ([has-wall] of new-patch-down))  [report (list "corner" [pxcor] of new-patch-right [pycor] of new-patch-right)]
    ([has-wall] of new-patch-right)   [report (list "right" [pxcor] of new-patch-right [pycor] of new-patch-right)]
    ([has-wall] of new-patch-down)   [report (list "down" [pxcor] of new-patch-down [pycor] of new-patch-down)]
    ([has-wall] of new-patch)        [report (list "corner" [pxcor] of new-patch [pycor] of new-patch)]
    [report false]
  )
end

to-report check-wall-collision-quadrant-3
  let new-patch patch-ahead lookAhead
  if new-patch = nobody [report false]
  let new-patch-left  patch-at-heading-and-distance  -90 lookAhead
  let new-patch-down  patch-at-heading-and-distance  180 lookAhead
  if (new-patch-left = nobody) [set new-patch-left patch-here]  ; if at edge of world
  if (new-patch-down = nobody) [set new-patch-down patch-here]  ; if at edge of world

  (ifelse
    (([has-wall] of new-patch-left) and ([has-wall] of new-patch-down))  [report (list "corner" [pxcor] of new-patch-left [pycor] of new-patch-left)]
    ([has-wall] of new-patch-left)   [report (list "left" [pxcor] of new-patch-left [pycor] of new-patch-left)]
    ([has-wall] of new-patch-down)   [report (list "down" [pxcor] of new-patch-down [pycor] of new-patch-down)]
    ([has-wall] of new-patch)        [report (list "corner" [pxcor] of new-patch [pycor] of new-patch)]
    [report false]
  )
end

to-report check-wall-collision-quadrant-4
  let new-patch patch-ahead lookAhead
  if new-patch = nobody [report false]
  let new-patch-left  patch-at-heading-and-distance  -90 lookAhead
  let new-patch-up    patch-at-heading-and-distance    0 lookAhead
  if (new-patch-left = nobody) [set new-patch-left patch-here]  ; if at edge of world
  if (new-patch-up = nobody) [set new-patch-up patch-here]  ; if at edge of world

  (ifelse
    (([has-wall] of new-patch-left) and ([has-wall] of new-patch-up)) [report (list "corner" [pxcor] of new-patch-left [pycor] of new-patch-left)]
    ([has-wall] of new-patch-left)   [report (list "left" [pxcor] of new-patch-left [pycor] of new-patch-left)]
    ([has-wall] of new-patch-up)     [report (list "up" [pxcor] of new-patch-up [pycor] of new-patch-up)]
    ([has-wall] of new-patch)        [report (list "corner" [pxcor] of new-patch [pycor] of new-patch)]
    [report false]
  )
end

to-report wall-collision-direction-and-xy
 let quadrant heading-quadrant
 (ifelse
   quadrant = 1 [report check-wall-collision-quadrant-1]
   quadrant = 2 [report check-wall-collision-quadrant-2]
   quadrant = 3 [report check-wall-collision-quadrant-3]
   quadrant = 4 [report check-wall-collision-quadrant-4]
 )
  report false
end

to check-for-wall-collision ;  if next to wall patch, change speed and heading of ball
  let direction-and-pos wall-collision-direction-and-xy
  if direction-and-pos != false [
    let direction item 0  direction-and-pos
    let -xcor item 1  direction-and-pos
    let -ycor item 2  direction-and-pos
    perform-hit-wall direction -xcor -ycor
  ]
end

to change-heading-if-collides-with-wall [heading-change]
  let direction-and-pos wall-collision-direction-and-xy
  if direction-and-pos != false [
    let direction item 0  direction-and-pos
    let -xcor item 1  direction-and-pos
    let -ycor item 2  direction-and-pos
    collide-with-wall heading-change direction -xcor -ycor
  ]
end

to-report has-collided-with-wall
  report (last-tick-wall-collision-occured = ticks) or (wall-collision-direction-and-xy != false)
end

to change-speed-if-collides-with-wall [speed-change]
  if has-collided-with-wall [
    change-speed-after-wall-collision prop "wall-speed"
  ]
end

;ball procedure
to change-heading-after-wall-collision [wall-direction heading-change]
  if (heading-change = "no change")[]
  if (heading-change = "turn left")[  set heading (heading - 90 ) ]
  if (heading-change = "turn right")[ set heading (heading + 90 )  ]
  if (heading-change = "collide")[bounce wall-direction]  ; change heading (speed remains the same)
end

to change-speed-after-wall-collision [speed-change]
  if (speed-change = "zero")     [ set speed 0 ]
  if (speed-change = "increase")[set speed speed + deltaSpeed]
  if (speed-change = "decrease")[set speed speed - deltaSpeed]
  if (speed-change = "collide") and (speed-change != "collide")
                     [user-message (word "You cannot pair non-collide heading change with collide speed change.")]
end

to set-ball-speed-to-maximum-if-above-max-speed
  if (speed > max-speed) [set speed max-speed]
end

; patch procedure
to flash-wall-here
  if has-wall [
    flash-patch pcolor + 2 ]
end

to flash-wall-at [-xcor -ycor]
  if flash-wall-collision [
    ask patch -xcor -ycor [flash-wall-here] ]
end

to increase-wall-collision-count-for-ball-population
  increment-table-value wall-collision-count population-num 1
end

to collide-with-wall [heading-change wall-direction xpos ypos]
  increase-wall-collision-count-for-ball-population
  on-wall-hit xpos ypos
  change-heading-after-wall-collision wall-direction heading-change
end

to perform-hit-wall [wall-direction xpos ypos]
  increase-wall-collision-count-for-ball-population
  on-wall-hit xpos ypos
  change-heading-after-wall-collision wall-direction prop "wall-heading"
  change-speed-after-wall-collision prop "wall-speed"
end

to on-wall-hit [xpos ypos]
  flash-wall-at xpos ypos
  set last-tick-wall-collision-occured ticks
end

to bounce [direction]
;  sets new heading of ball when hits wall
;  direction is the direction of the wall from ball "left" "right" "up" "down" "corner"

  if ((direction = "right") or (direction = "left")) [set heading (-1 * heading)]  ; hit a horizontal wall
  if ((direction = "up")    or (direction = "down")) [set heading (180 - heading)] ; hit vertical wall
  if (direction = "corner")                          [set heading (180 + heading)] ; hit wall at a corner
  ;set last-collision nobody
end

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;collision;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report should-perform-collision-with [other-ball]
  ;report (who < [who] of other-ball) and (other-ball != last-collision)
  report not already-collided-with? other-ball
end

to remember-collided-with [other-ball]
  set balls-collided-with (turtle-set balls-collided-with other-ball)
end

to-report already-collided-with? [other-ball]
  report member? other-ball balls-collided-with
end

to-report balls-colliding
  report collision-candidates with [ball-collides-with myself]
end

to-report balls-colliding-from [other-balls]
  report balls-colliding with [member? self other-balls]
end

to change-heading-if-collides-with [other-balls heading-change]
  ask balls-colliding-from other-balls [
    if should-perform-collision-with myself [
      ask myself [perform-collision-heading-change myself heading-change  remember-collided-with myself ] ;set last-collision  myself]
      ;set last-collision myself
      remember-collided-with myself
    ]
  ]
end

to change-speed-if-collides-with [other-balls speed-change]
  ask collision-candidates-with other-balls [
    if ball-collides-with myself [
        ask myself [perform-collision-speed-change speed-change]
    ]
  ]
end

to perform-collision-heading-change [other-ball heading-change]
  ; close duplication of other function
  (ifelse
    (heading-change = "no change") []
    (heading-change = "turn left") [  set heading (heading - 90) ask other-ball [set heading (heading - 90)]]
    (heading-change = "turn right") [ set heading (heading + 90 ) ask other-ball [set heading (heading + 90)]]
    (heading-change = "collide") [collide-with other-ball]
  )
end

to perform-collision-speed-change [speed-change]
  (ifelse
    (speed-change = "zero")    [set speed 0]
    (speed-change = "increase")[set speed speed + deltaSpeed]
    (speed-change = "decrease")[set speed speed - deltaSpeed]
  )
end

to perform-collision-speed-change-old [other-ball speed-change]
  ; close duplication of other function
  (ifelse
    (speed-change = "zero")    [set speed 0 ask other-ball [set speed 0]]
    (speed-change = "increase")[set speed speed + deltaSpeed ask other-ball [set speed speed + deltaSpeed]]
    (speed-change = "decrease")[set speed speed - deltaSpeed ask other-ball [set speed speed - deltaSpeed]]
  )
end


to-report collision-candidates-with [other-balls]
  report collision-candidates with [member? self other-balls]
end

to-report collision-candidates-of [population]
  report collision-candidates with [population-num = population]
end

to-report collision-candidates-from [ball-set]
  report collision-candidates with [member? self ball-set]
end

to-report in-radius-candidates [radius]
  let -length abs ((round (xcor - (radius / 2))) - (round (xcor + (radius / 2) ))) + 1
  let top-left-xcor (round (xcor - (radius / 2)))
  let top-left-ycor (round (ycor + (radius / 2)))
  report other (turtle-set n-values (-length ^ 2) [i ->
    ifelse-value abs (top-left-xcor + i mod -length) < max-pxcor and abs (top-left-ycor - int(i / -length)) < max-pycor
                 [[balls-here] of patch (top-left-xcor + i mod -length) (top-left-ycor - int(i / -length))] [nobody]])
end

to-report collision-candidates
  let -length abs ((round (xcor - (size / 2))) - (round (xcor + (size / 2) ))) + 1
  let top-left-xcor (round (xcor - (size / 2)))
  let top-left-ycor (round (ycor + (size / 2)))
  report other (turtle-set n-values (-length ^ 2) [i ->
    ifelse-value abs (top-left-xcor + i mod -length) < max-pxcor and abs (top-left-ycor - int(i / -length)) < max-pycor
                 [[balls-here] of patch (top-left-xcor + i mod -length) (top-left-ycor - int(i / -length))] [nobody]])
end

to-report ball-collides-with [other-ball]
  let interBallMaxDist  ((size + [size] of other-ball) / 2)
  let ourDistance distance other-ball
  report (ourDistance <= interBallMaxDist  and ourDistance >= interBallMaxDist - eps-collision)
end

to check-for-collision-with-population [population]
  ask collision-candidates-of population [
    if ball-collides-with myself [
      if should-perform-collision-with myself [
        ask myself [perform-collision myself]; set last-collision  myself]
        ;set last-collision myself
      ]
    ]
  ]
end

to check-for-ball-collision
  ; check if 2 balls collide. If so Change speed and heading of the 2 balls

  ; Here we impose a rule that collisions only take place when there
  ; are exactly two balls per patch.  We do this because when the
  ; student introduces new balls from the side, we want them to
  ; form a uniform wavefront.
  ;;
  ; Why do we want a uniform wavefront?  Because it is actually more
  ; realistic.  (And also because the curriculum uses the uniform
  ; wavefront to help teach the relationship between ball collisions,
  ; wall hits, and pressure.)
  ;;
  ; Why is it realistic to assume a uniform wavefront?  Because in reality,
  ; whether a collision takes place would depend on the actual headings
  ; of the balls, not merely on their proximity.  Since the balls
  ; in the wavefront have identical speeds and near-identical headings,
  ; in reality they would not collide.  So even though the two-balls
  ; rule is not itself realistic, it produces a realistic result.  Also,
  ; unless the number of balls is extremely large, it is very rare
  ; for three or more balls to land on the same patch (for example,
  ; with 400 balls it happens less than 1% of the time).  So imposing
  ; this additional rule should have only a negligible effect on the
  ; aggregate behavior of the system.
  ;;
  ; Why does this rule produce a uniform wavefront?  The balls all
  ; start out on the same patch, which means that without the only-two
  ; rule, they would all start colliding with each other immediately,
  ; resulting in much random variation of speeds and headings.  With
  ; the only-two rule, they are prevented from colliding with each other
  ; until they have spread out a lot.  (And in fact, if you observe
  ; the wavefront closely, you will see that it is not completely smooth,
  ; because some collisions eventually do start occurring when it thins out while fanning.)

  ; Collision occurs if there is a ball in the same patch at the borders of the balls  (GIGI at this point assume a ball can collide with only 1 ball)
    ; the following conditions are imposed on collision candidates:
    ;   1. they must have a lower who number than my own, because collision
    ;      code is asymmetrical: it must always happen from the point of view
    ;      of just one ball.
    ;      Update: Balls now keep track with who they collided with in current tick, instead of checking for who numbers.
    ;   2. they must not be the same ball that we last collided with on
    ;      this patch, so that we have a chance to leave the patch after we've
    ;      collided with someone.

  ;ask collision-candidates [
  ;  if ball-collides-with myself [
  ask balls in-radius 3 with [member? self balls and (((xcor - [xcor] of myself) ^ 2 + (ycor - [ycor] of myself) ^ 2) < (([size] of myself) ^ 2))] [
  ;ask (in-radius-candidates 3) with [member? self balls and (((xcor - [xcor] of myself) ^ 2 + (ycor - [ycor] of myself) ^ 2) < (([size] of myself) ^ 2))] [
      if should-perform-collision-with myself [
      ask myself [perform-collision myself]; set last-collision  myself]
        ;set last-collision myself
      ]
  ]
  ;  ]
  ;]
end

to-report balls-belong-to-same-population [ball1 ball2]
  report [population-num] of ball1 = [population-num] of ball2
end

to-report collision-heading-change [other-ball]
  report ifelse-value balls-belong-to-same-population self other-ball
                       [prop "ball-heading"] [prop "other-ball-heading"]
end

to-report collision-speed-change [other-ball]
  report ifelse-value balls-belong-to-same-population self other-ball
                       [prop "ball-speed"] [prop "other-ball-speed"]
end

to perform-collision-heading-change-with [other-ball]
  let heading-change collision-heading-change other-ball
  let speed-change collision-speed-change other-ball
  (ifelse
    (heading-change = "no change")[]
    (heading-change = "turn left")[  set heading (heading - 90) ask other-ball [set heading (heading - 90)]]
    (heading-change = "turn right")[ set heading (heading + 90 ) ask other-ball [set heading (heading + 90)]]
    ((heading-change = "collide") and (speed-change = "collide")) [collide-with other-ball ]   ; changes heading and speed of BOTH  balls
    ((heading-change = "attract") and (speed-change = "attract")) [collide-with other-ball ]   ; changes heading and speed of BOTH  balls
  )
end

to perform-collision-speed-change-with [other-ball]
  let speed-change collision-speed-change other-ball
  let heading-change collision-heading-change other-ball
  (ifelse
    (speed-change = "zero")    [set speed 0 ask other-ball [set speed 0]]
    (speed-change = "increase")[set speed speed + deltaSpeed ask other-ball [set speed speed + deltaSpeed]]
    (speed-change = "decrease")[set speed speed - deltaSpeed ask other-ball [set speed speed - deltaSpeed]]
    ((speed-change = "collide") and (heading-change != "collide")) or ((speed-change != "collide") and (heading-change = "collide"))
                      [user-message (word "You cannot pair non-collision heading change with collision speed change.")]
    ((speed-change = "attract") and (heading-change != "attract")) or ((speed-change != "attract") and (heading-change = "attract"))
                      [user-message (word "You cannot pair non-attraction heading change with attraction speed change.")]
  )
end

;ball procedure
to perform-collision [other-ball]
  perform-collision-heading-change-with other-ball
  perform-collision-speed-change-with other-ball
end

to collide-with [other-ball] ;;
; implements a collision with another ball.
;;
; THIS IS THE HEART OF THE PARTICLE SIMULATION, AND YOU ARE STRONGLY ADVISED
; NOT TO CHANGE IT UNLESS YOU REALLY UNDERSTAND WHAT YOU'RE DOING!
;;
; The two balls colliding are self and other-ball, and while the
; collision is performed from the point of view of self, both balls are
; modified to reflect its effects. This is somewhat complicated, so I'll
; give a general outline here:
;   1. Do initial setup, and determine the heading between ball centers
;      (call it theta).
;   2. Convert the representation of the velocity of each ball from
;      speed/heading to a theta-based vector whose first component is the
;      ball's speed along theta, and whose second component is the speed
;      perpendicular to theta.
;   3. Modify the velocity vectors to reflect the effects of the collision.
;      This involves:
;        a. computing the velocity of the center of mass of the whole system
;           along direction theta
;        b. updating the along-theta components of the two velocity vectors.
;   4. Convert from the theta-based vector representation of velocity back to
;      the usual speed/heading representation for each ball.
;   5. Perform final cleanup and update derived quantities.

  let mass2 0
  let speed2 0
  let heading2 0
  let theta 0
  let v1t 0
  let v1l 0
  let v2t 0
  let v2l 0
  let vcm 0

  ; Step 0 - If one of the populations shouldnt move (==ballsX-forward == FALSE) the other ball should bounce bck (heading = -heading)
  ; Actually we enter here with myself is moving. Cant be that my balls-forward is FALSE
  ;refactor
  let this-ball-is-moving ball-can-move
  let other-ball-is-moving [ball-can-move] of other-ball
  let both-balls-are-moving this-ball-is-moving and other-ball-is-moving

  if not this-ball-is-moving [
    ask other-ball [ set heading heading + 180  ] ; heading is reflected but speed remains the same and my speed+heading doesnt change (but is irrelevt anyway)
  ]

  if not other-ball-is-moving [
    set heading  heading + 180  ; heading is reflected but speed remains the same and my speed+heading doesnt change (but is irrelevt anyway)
  ]

  if both-balls-are-moving
  [

  ;; PHASE 1: initial setup

  ; for convenience, grab some quantities from other-ball
  set mass2 [mass] of other-ball
  set speed2 [speed] of other-ball
  set heading2 [heading] of other-ball

  ; since balls are modeled as zero-size points, theta isn't meaningfully
  ; defined. we can assign it randomly without affecting the model's outcome.
  set theta (random-float 360)



  ;; PHASE 2: convert velocities to theta-based vector representation

  ; now convert my velocity from speed/heading representation to components
  ; along theta and perpendicular to theta
  set v1t (speed * cos (theta - heading))
  set v1l (speed * sin (theta - heading))

  ; do the same for other-ball
  set v2t (speed2 * cos (theta - heading2))
  set v2l (speed2 * sin (theta - heading2))



  ;; PHASE 3: manipulate vectors to implement collision

  ; compute the velocity of the system's center of mass along theta
  set vcm (((mass * v1t) + (mass2 * v2t)) / (mass + mass2) )

  ; now compute the new velocity for each ball along direction theta.
  ; velocity perpendicular to theta is unaffected by a collision along theta,
  ; so the next two lines actually implement the collision itself, in the
  ; sense that the effects of the collision are exactly the following changes
  ; in ball velocity.
  set v1t (2 * vcm - v1t)
  set v2t (2 * vcm - v2t)

  ;; PHASE 4: convert back to normal speed/heading

  ; now convert my velocity vector into my new speed and heading
  set speed sqrt ((v1t * v1t) + (v1l * v1l))
  ; if the magnitude of the velocity vector is 0, atan is undefined. but
  ; speed will be 0, so heading is irrelevant anyway. therefore, in that
  ; case we'll just leave it unmodified.
   ; make sure speed does not exceed limit
   if (speed > max-speed) [set speed max-speed]
   if v1l != 0 or v1t != 0
    [ set heading (theta - (atan v1l v1t)) ]

  ; and do the same for other-ball
  ask other-ball [
    set speed sqrt ((v2t ^ 2) + (v2l ^ 2))
    if v2l != 0 or v2t != 0
      [ set heading (theta - (atan v2l v2t)) ]
  ]

  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GRAVITY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to update-electricity   ; updates the per patch gravity field vector by adding the fields for each ball
  let ball-pos-x 0
  let ball-pos-y 0
  let dist 0
  let max-electric-strength 10  ; this needs to become a global variable set from a button in the interface
  let patch-list []
  set patch-list patches

  ; first null the electric field
  ask patches [
     set field-x  0
     set field-y  0
  ]

  ask balls
  [
      ask patch-list [
;  [ foreach patch in-radius 10000 [
    set field-x  field-x + 1
;    ]
  ]
  ]
;   ; per ball update the electric field in each patch
 ask balls [
    set ball-pos-x xcor
    set ball-pos-y ycor

    ask patch-list [
      set dist  sqrt max ( list ((pxcor - ball-pos-x) ^ 2 + (pycor - ball-pos-y) ^ 2)  1)   ; dist holds distance to patch but does not alllow 0

      set field-x  (field-x +   (pxcor - ball-pos-x) / (dist ^ 3)  * max-electric-strength)
      set field-y  (field-y +   (pycor - ball-pos-y) / (dist ^ 3)  * max-electric-strength)
  ]
  ]
end

to-report own-population-repels-or-attracts-ball
  report member? prop "ball-heading" ["repel" "attract" "repel and attract"]
end

to-report other-populations-repel-or-attract-ball
  let other-populations remove population-num population-numbers
  foreach other-populations [population -> if population-repels-or-attracts-other-populations? population [report true]]
  report false
end

to-report is-ball-affected-by-repel-or-attract-forces
  report own-population-repels-or-attracts-ball or other-populations-repel-or-attract-ball
end

to-report balls-of [population]
  report table:get-or-default balls-by-population population no-turtles
end

to apply-force-on [other-balls force]
  let  mypos-x xcor
  let  mypos-y ycor
  let dist 0  ; will be used to calculate distance between balls

  ask other-balls
  [
    (ifelse
      force = "repel" [
        set dist sqrt max ( list ((xcor - mypos-x) ^ 2 + (ycor - mypos-y) ^ 2) 1)  ; dist holds distance to patch but does not alllow 0
        set force-x-sum  (force-x-sum -   (mypos-x - xcor) / (dist ^ 3)  * repulsion-strength)
        set force-y-sum  (force-y-sum -   (mypos-x - ycor) / (dist ^ 3)  * repulsion-strength)
      ]

      force = "attract" [
        set dist  sqrt max ( list ((xcor - mypos-x) ^ 2 + (ycor - mypos-y) ^ 2) 1)  ; dist holds distance to patch but does not alllow 0
        set force-x-sum  (force-x-sum  +   (mypos-x - xcor) / (dist ^ 3)  * attraction-strength)
        set force-y-sum  (force-y-sum  +   (mypos-y - ycor) / (dist ^ 3)  * attraction-strength)
      ]

      force = "repel and attract" [
        set dist  sqrt max ( list ((xcor - mypos-x) ^ 2 + (ycor - mypos-y) ^ 2) 1)  ; dist holds distance to patch but does not alllow 0
        set LJsigma size  ; set this LJ param to be size of ball
        let lj-force ((24 * LJeps / LJsigma ^ 2 * ( 2 * (LJsigma / (dist )) ^ 14 - (LJsigma / (dist)) ^ 8 ) ))  ;LJ formula from Eilon's code
        set force-x-sum  (force-x-sum    - lj-force *  (mypos-x - xcor) / (dist))     ; (xcor - mypos-x) / (dist)  is sin(theta)
        set force-y-sum  (force-y-sum    - lj-force *  (mypos-y - ycor) / (dist))     ; (ycor - mypos-y) / (dist)  is cos(theta)
      ]
    )
  ]
end

to apply-forces-acting-on-ball
  let vx (sin heading * speed) + (force-x-sum * tick-advance-amount)
  let vy (cos heading * speed) + (force-y-sum * tick-advance-amount)
  set speed sqrt ((vy ^ 2) + (vx ^ 2))
  if ((vx != 0) or (vy != 0))  [set heading atan vx vy]
end

to-report force-vector-acting-on-ball
  let my-field-x 0 ; null my field data
  let my-field-y 0 ; null my field data
  let  mypos-x xcor
  let  mypos-y ycor
  let distance-between-balls 0
  let force 0 ; will hold the LJ force between 2 balls

  ask other balls
  [
    let heading-change collision-heading-change myself
    let speed-change collision-speed-change myself

    if ((heading-change = "repel") and (speed-change = "repel")) [ ; add repulsion factor to my field
      set distance-between-balls  sqrt max ( list ((xcor - mypos-x) ^ 2 + (ycor - mypos-y) ^ 2) 1)  ; dist holds distance to patch but does not alllow 0
      set my-field-x  (my-field-x -   (xcor - mypos-x) / (distance-between-balls ^ 3)  * repulsion-strength)
      set my-field-y  (my-field-y -   (ycor - mypos-y) / (distance-between-balls ^ 3)  * repulsion-strength)
    ]
    if ((heading-change = "attract") and (speed-change = "attract")) [ ; add attraction factor to my field
      set distance-between-balls  sqrt max ( list ((xcor - mypos-x) ^ 2 + (ycor - mypos-y) ^ 2) 1)  ; dist holds distance to patch but does not alllow 0
      set my-field-x  (my-field-x  +   (xcor - mypos-x) / (distance-between-balls ^ 3)  * attraction-strength)
      set my-field-y  (my-field-y  +   (ycor - mypos-y) / (distance-between-balls ^ 3)  * attraction-strength)
    ]
    if ((heading-change = "repel and attract") and (speed-change = "repel and attract")) [ ; add leonard-Jones factor to my field
      set distance-between-balls  sqrt max ( list ((xcor - mypos-x) ^ 2 + (ycor - mypos-y) ^ 2) 1)  ; dist holds distance to patch but does not alllow 0
      set LJsigma size  ; set this LJ param to be size of ball
      set force ((24 * LJeps / LJsigma ^ 2 * ( 2 * (LJsigma / (distance-between-balls )) ^ 14 - (LJsigma / (distance-between-balls)) ^ 8 ) ))  ;LJ formula from Eilon's code
      set my-field-x  (my-field-x    - force *  (xcor - mypos-x) / (distance-between-balls))     ; (xcor - mypos-x) / (dist)  is sin(theta)
      set my-field-y  (my-field-y    - force *  (ycor - mypos-y) / (distance-between-balls))     ; (ycor - mypos-y) / (dist)  is cos(theta)
    ]
  ]

  let vx (sin heading * speed) + (my-field-x * tick-advance-amount)
  let vy (cos heading * speed) + (my-field-y * tick-advance-amount)
  report (list vx vy)
end



to factor-repel-and-attract-forces  ; turtle procedure consider repel and attract forces
  if is-ball-affected-by-repel-or-attract-forces [
    let force-vector force-vector-acting-on-ball
    let vx first force-vector
    let vy last force-vector
    set speed sqrt ((vy ^ 2) + (vx ^ 2))
    if ((vx != 0) or (vy != 0))  [set heading atan vx vy]
  ]
end

to apply-electric-field [field-strength]
  if field-count > 0 [
    let vx ((sin heading) * speed) + ([field-x] of patch-here * field-strength * tick-advance-amount)
    let vy ((cos heading) * speed) + ([field-y] of patch-here * field-strength * tick-advance-amount)
    set speed sqrt ((vy ^ 2) + (vx ^ 2))
    if ((vx != 0) or (vy != 0))  [set heading atan vx vy]
  ]
end

to factor-electric-field
  apply-electric-field prop "electric-field"
end

to apply-gravity [strength]  ; turtle procedure
  ;if speed = 0 [stop]  ; GIGI - why? if speed is 0 then should increase by gravity...
  let vx (sin heading * speed) + (gravity-acceleration-x * tick-advance-amount)
  let vy (cos heading * speed) + (strength * tick-advance-amount)
  set speed sqrt ((vy ^ 2) + (vx ^ 2))
  set heading atan vx vy
end

to factor-gravity  ; turtle procedure
  if is-affected-by-gravity [apply-gravity (- prop "gravity")]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;STICK;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;to stick
;  set stick-to-wall? true
;        set leader self
;  if has-wall [set stuck-on-wall? true]
;
;end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;earser;;;;;;;;;;;;;;;

to setup   ; called from START NEW TASK button
  ; counting block spaces is slow so keep result between resets
  ;let tmp-amount-of-block-spaces amount-of-block-spaces
  clear-all
  ;set amount-of-block-spaces tmp-amount-of-block-spaces
  initialize-world
  ifelse netlogo-web? [update-ball-population-properties-defined-in-nettango-blocks] [crt-pop]
  ;update-ball-population-properties-defined-in-nettango-blocks
  select-next-population-in-properties-ui
  setup-brush
  recolor-all-patches
  update-display
  reset-ticks
end;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LOGGING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report delimit [-left delimiter -right]
  report (word -left delimiter -right)
end

to-report delimit-comma [-left -right]
  report delimit -left "," -right
end

to-report delimit-hashtag [-left -right]
  report delimit -left ",#," -right
end

to-report delimited-population-settings [population -settings]
  report reduce delimit-comma map [property -> pprop population property] -settings
end

to-report delimited-all-populations-settings [-settings]
  report reduce delimit-hashtag map [population -> delimited-population-settings population -settings] population-numbers
end

to-report delimited-all-populations-numerous-settings [settings-list]
  report reduce delimit-hashtag map [settings -> delimited-all-populations-settings settings] settings-list
end

to-report populations-settings-delimited-string
  let properties ["size" "color" "speed" "heading"]
  let actions ["move"]
  let interactions ["wall-heading" "wall-speed" "ball-heading" "ball-speed"
        "other-ball-heading" "other-ball-speed" "gravity" "electric-field"]
  report delimited-all-populations-numerous-settings (list properties actions interactions)
end

to-report count-balls-in-population [population]
  report count balls with [population-num = population]
end

to-report amount-of-balls-being-traced
  report count balls with [pen-mode = "down"]
end

to-report delimited-population-count
  report reduce delimit-comma map count-balls-in-population population-numbers
end

to-report delimited-log-string
  report (word populations-settings-delimited-string "," amount-of-balls-being-traced "," delimited-population-count "," current-background-color)
end

to-report log-header
   report (word " Date = "  date-and-time " , Command Name, ticks, ball1-Properties,  balls1-Size,balls1-color,balls1-init-speed,balls1-init-heading,"
                " balls2-Properties , balls2-Size,balls2-color,balls2-init-speed,balls2-init-heading,"
                "balls1-Actions , balls1-forward , balls2-Actions , balls2-forward,"
                " balls1-Interactions, if-hit-wall-heading1,if-hit-wall-speed1,if-meet-ball-heading1,if-meet-ball-speed1"
                ", balls2-Interactions,if-hit-wall-heading2,if-hit-wall-speed2,if-meet-ball-heading2,if-meet-ball-speed2 , "
                " balls1&balls2-Interactions ,if-meet-ball-heading ,if-meet-ball-speed , , trace-a-ball? ,num-balls1 , num-balls2 , background-color, Electric-Field-Strength,"
                " Gravity-field " )
end

to set-new-log-filename [fileName]
  let timestamp date-and-time
  let timestamp-no-colon replace-item 2 timestamp "-"
  set timestamp-no-colon replace-item 5 timestamp-no-colon "-"
  set log-filename (word fileName "_" substring timestamp-no-colon 16 27 "_" substring timestamp-no-colon 0 8 ".csv")
end

to setup-logging  [fileName]
  set-new-log-filename fileName
  if log-enabled [
    set log-history log-header
    send-to:file log-filename log-history
  ]
end

to set-new-log-photo-filename
  set log-filename-photo (word substring log-filename 0 (length log-filename - 4) "_" log-picture-count ".png")
end

to log_picture
  if log-enabled [
    set-new-log-photo-filename
    export-view log-filename-photo
  ]
end

to-report test-if-log-output [command-name]
  ifelse log-enabled [
    let new-line (word command-name  ",#," delimited-log-string)
    ifelse (new-line = prev-line) [report FALSE] [report TRUE]
  ] [report false]
end

to add-log-history [new-log]
 set log-history word log-history new-log
end

to log-command [command-name]
  if (prev-command-name != command-name) [log-output command-name]
end

to log-output [command-name]
  if log-enabled [
    add-log-history (word timer "," command-name "," ticks ",#," delimited-log-string)
    send-to:file log-filename log-history
  set prev-command-name command-name
  set prev-line (word command-name  ",#,"  delimited-log-string)
  ]
end

to make-halo  ; runner procedure
  ; when you use HATCH, the new turtle inherits the
  ; characteristics of the parent.  so the halo will
  ; be the same color as the turtle it encircles (unless
  ; you add code to change it
  hatch-halos 1
  [ set size 5
    ; Use an RGB color to make halo three fourths transparent
    set color lput 64 extract-rgb color
    ; set thickness of halo to half a patch
    ; __set-line-thickness 0.5 ;refactor nlw doesnt support this
    ; We create an invisible directed link from the runner
    ; to the halo.  Using tie means that whenever the
    ; runner moves, the halo moves with it.
    create-link-from myself
    [ tie
      hide-link ]
  ]
  log-command "make-halo"
end

to save-existing-layout
  let file-name user-input "איזה שם לתת לקובץ?"
  export-world (word file-name)
  log-command "save-existing-layout"
end

to load-existing-layout
  fetch:user-file-async [file-name ->
    if file-name != false [try-import-world-file file-name]]
  log-command "load-existing-layout"
end

to try-import-world-file [file-name]
  carefully [
    import-a:world file-name
  ] [
    user-message "אין אפשרות לטעון את הקובץ"
  ]
end

;patch procedure
to-report patch-has-wall
  report has-wall
end

;patch procedure
to-report patch-has-balls
  report count balls-here > 0
end

;patch procedure
to-report can-attempt-to-create-wall-in-patch
  report not patch-has-wall
end

; patch procedure
to try-to-push-aside-balls-from-patch
  ask balls-here [try-to-move-to-closest-unblocked-neighbors4-patch]
end

;turtle procedure
to try-to-move-to-closest-unblocked-neighbors4-patch
  let closest-unblocked-neighbor-patch closest-unblocked-neighbors4-patch self
  let unblocked-neighbor-exists closest-unblocked-neighbor-patch != nobody
  if unblocked-neighbor-exists [
    move-to closest-unblocked-neighbor-patch
    randomly-move-ball-inside-radius 0.01
  ]
end

to-report closest-unblocked-neighbors4-patch [-turtle]
  let patch-turtle-is-on [patch-here] of -turtle
  report min-one-of unblocked-neighbor4-patches patch-turtle-is-on [distance patch-turtle-is-on]
end

to-report unblocked-neighbor4-patches [-patch]
  report ([neighbors4] of -patch) with [not patch-has-wall]
end

to-report can-create-wall-in-patch
  report (not patch-has-wall) and (not patch-has-balls)
end

;patch procedure
to create-wall-in-patch
  if can-attempt-to-create-wall-in-patch [
    try-to-push-aside-balls-from-patch
    if can-create-wall-in-patch [
      set has-wall true
      recolor-patch
    ]
  ]
end

; patch procedure
to remove-wall-in-patch
  if patch-has-wall [
    set has-wall false
    recolor-patch
  ]
end

to erase-all-balls-of-population-selected-in-ui
  if is-a-population-selected-in-ui [ask balls-of population-to-set-properties-for-in-ui [remove-ball]]
end

;======== BRUSH ===========================

to setup-brush
  set mouse-down?-when-brush-was-last-activated false
  set mousexy-when-brush-was-last-activated [ ]
  set patches-drawn-on-since-brush-was-held-down no-patches
  set current-mousexy (list mouse-xcor mouse-ycor)
  set current-mouse-down? mouse-down?
  set current-mouse-inside?  mouse-inside?
  set brush-in-draw-mode true
  set brush-style "free-form"
  set brush-shape "square"
  set brush-type "wall"
  set brush-icon-size 4
  set shape-drawn-by-brush "rectangle"
  set center-patch-of-drawn-shape nobody
  set patches-affected-by-drawn-shape no-patches
  set brush-icon-transparency-normalized 0.8
  set gfx-displaying-patches-affected-by-drawn-shape no-turtles
  create-brush-border-outlines 1 [hide-turtle set -brush-border-outline self]
  create-brush-cursors 1 [hide-turtle set -brush-cursor self]
  create-gfx-overlay 1 [set brush-type-icon self
    set color add-transparency red brush-icon-transparency-normalized
    setxy (max-pxcor - brush-icon-size - ((brush-icon-size - 1) * 0.5)) (max-pycor - ((brush-icon-size - 1) * 0.5))
    set size brush-icon-size]
  create-gfx-overlay 1 [set brush-draw-erase-mode-icon self
    set color add-transparency red brush-icon-transparency-normalized
    setxy (max-pxcor - ((brush-icon-size - 1) * 0.5)) (max-pycor - ((brush-icon-size - 1) * 0.5))
    set size brush-icon-size ]
  update-brush-cursor-icon
  update-brush-type-icon
  update-brush-add-erase-mode-icon
end

to draw-with-brush
  (ifelse
    brush-style = "free-form" [draw-with-free-form-brush]
    brush-style = "shape" [draw-shape-with-brush])
end

to draw-shape-with-brush
  (ifelse
    is-brush-pressed-down [configure-new-shape-with-brush]
    brush-is-held-down [configure-current-shape-with-brush]
    brush-has-been-clicked [draw-shape-configured-by-brush remove-gfx-display-of-patches-to-be-affected-by-drawn-shape log-shape-drawn] )
end

to set-center-for-drawn-shape
  set center-patch-of-drawn-shape patch-under-brush
end

to configure-new-shape-with-brush
  set-center-for-drawn-shape
  set patches-affected-by-drawn-shape patch-set patch-under-brush
  update-display-of-patches-to-be-affected-by-drawn-shape
end

to configure-current-shape-with-brush
  if is-new-size-configured-for-drawn-shape [
    set-patches-to-be-affected-by-current-drawn-shape-configuration
    update-display-of-patches-to-be-affected-by-drawn-shape
  ]
end

to-report is-new-size-configured-for-drawn-shape
  let current-distance-of-patch-under-brush-from-shape-center [distance center-patch-of-drawn-shape] of patch-under-brush
  let former-distance-of-patch-under-brush-from-shape-center [distance center-patch-of-drawn-shape] of (patch-at-point mousexy-when-brush-was-last-activated)
  report current-distance-of-patch-under-brush-from-shape-center != former-distance-of-patch-under-brush-from-shape-center
end

to update-display-of-patches-to-be-affected-by-drawn-shape
  remove-gfx-display-of-patches-to-be-affected-by-drawn-shape
  add-gfx-display-of-patches-to-be-affected-by-drawn-shape
end

to remove-gfx-display-of-patches-to-be-affected-by-drawn-shape
  ask gfx-displaying-patches-affected-by-drawn-shape [die]
end

to add-gfx-display-of-patches-to-be-affected-by-drawn-shape
  ask patches-affected-by-drawn-shape [visually-display-this-patch-as-affected-by-drawn-shape]
end

to visually-display-this-patch-as-affected-by-drawn-shape
  sprout-gfx-overlay 1 [
    set shape "square"
    set color yellow
    set gfx-displaying-patches-affected-by-drawn-shape (turtle-set gfx-displaying-patches-affected-by-drawn-shape self)
    set heading 0
  ]
end

to set-patches-to-be-affected-by-current-drawn-shape-configuration
  (ifelse
    shape-drawn-by-brush = "circle" [set-patches-to-be-affected-by-current-drawn-circle-configuration ]
    shape-drawn-by-brush = "rectangle" [set-patches-to-be-affected-by-current-drawn-rectangle-configuration ]
    shape-drawn-by-brush = "square" [set-patches-to-be-affected-by-current-drawn-square-configuration ]
    shape-drawn-by-brush = "line" [set-patches-to-be-affected-by-current-drawn-line-configuration ] )
end

to-report radius-of-circle-drawn-by-brush
  report [distance-no-wrap center-patch-of-drawn-shape] of patch-under-brush
end

to-report size-of-square-drawn-by-brush
  report max list (delta-pxcor center-patch-of-drawn-shape patch-under-brush) (delta-pycor center-patch-of-drawn-shape patch-under-brush)
end

to-report delta-pycor [patch1 patch2]
  report abs ([pycor] of patch1 - [pycor] of patch2)
end

to-report delta-pxcor [patch1 patch2]
  report abs ([pxcor] of patch1 - [pxcor] of patch2)
end

to set-patches-to-be-affected-by-current-drawn-line-configuration
  let point1 (list [pxcor] of center-patch-of-drawn-shape [pycor] of center-patch-of-drawn-shape)
  ;set patches-affected-by-drawn-shape patches-line-intersects point1 current-mousexy
  set patches-affected-by-drawn-shape patches-line-intersects-no-wrap item 0 point1 item 1 point1 item 0 current-mousexy item 1 current-mousexy
end

to set-patches-to-be-affected-by-current-drawn-rectangle-configuration
  let corner-xcor-delta-from-center delta-pxcor center-patch-of-drawn-shape patch-under-brush
  let corner-ycor-delta-from-center delta-pycor center-patch-of-drawn-shape patch-under-brush
  let width (corner-xcor-delta-from-center * 2) + 1
  let height (corner-ycor-delta-from-center * 2) + 1
  set patches-affected-by-drawn-shape patches-that-form-a-rectangular-border-around-center-patch-no-wrap center-patch-of-drawn-shape width height
end

to-report point-is-inside-world-no-wrap [point]
  let -pxcor round first point
  let -pycor round last point
  report (-pxcor >= min-pxcor) and (-pxcor <= max-pxcor) and (-pycor >= min-pycor) and (-pycor <= max-pycor)
end

to-report patches-that-form-a-rectangular-border-around-center-patch-no-wrap [center width height]
  let height-from-center (height - 1) / 2
  let width-from-center (width - 1) / 2
  let top-side-ycor [pycor] of center + height-from-center
  let bot-side-ycor [pycor] of center - height-from-center
  let right-side-xcor [pxcor] of center + width-from-center
  let left-side-xcor [pxcor] of center - width-from-center

  let top-side-patches patch-set map [point -> patch-at-point point]
    filter point-is-inside-world-no-wrap n-values (width) [x -> (list (left-side-xcor + x) top-side-ycor)]
  let bottom-side-patches patch-set map [point -> patch-at-point point]
    filter point-is-inside-world-no-wrap n-values (width) [x -> (list (left-side-xcor + x) bot-side-ycor)]
  let right-side-patches patch-set map [point -> patch-at-point point]
    filter point-is-inside-world-no-wrap n-values (height) [y -> (list right-side-xcor (bot-side-ycor + y))]
  let left-side-patches patch-set map [point -> patch-at-point point]
    filter point-is-inside-world-no-wrap n-values (height) [y -> (list left-side-xcor (bot-side-ycor + y))]

  report (patch-set top-side-patches bottom-side-patches right-side-patches left-side-patches)
end

to set-patches-to-be-affected-by-current-drawn-square-configuration
  let square-size size-of-square-drawn-by-brush
  let side-length (square-size * 2) + 1
  set patches-affected-by-drawn-shape patches-that-form-a-rectangular-border-around-center-patch-no-wrap center-patch-of-drawn-shape side-length side-length
end

to set-patches-to-be-affected-by-current-drawn-circle-configuration
  let radius radius-of-circle-drawn-by-brush
  set patches-affected-by-drawn-shape patches with [(distance-no-wrap center-patch-of-drawn-shape > radius - 0.5) and (distance-no-wrap center-patch-of-drawn-shape < radius + 0.5)]
end

to-report distance-no-wrap [-other]
  report sqrt ((pxcor - [pxcor] of -other) ^ 2 + (pycor - [pycor] of -other) ^ 2)
end

to-report is-shape-being-configured
  report has-center-of-drawn-shape-been-set-inside-world
end

to-report has-center-of-drawn-shape-been-set-inside-world
  report center-patch-of-drawn-shape != nobody
end

to-report is-brush-pressed-down
  report current-mouse-down? and (not mouse-down?-when-brush-was-last-activated)
end

to draw-with-free-form-brush
  ifelse brush-is-held-down [
    on-brush-is-held-down
    if is-brush-drawing-on-patches-not-drawn-on-since-brush-was-held-down [
      on-brush-drawing-only-once-per-patch]]
  [
    if brush-has-been-clicked [
      on-brush-has-been-clicked]
  ]
end

to-report brush-has-been-clicked
  report (not brush-is-held-down) and (brush-was-held-down-last-time-brush-was-activated)
end

to-report brush-was-held-down-last-time-brush-was-activated
  report mouse-down?-when-brush-was-last-activated
end

to-report patches-under-brush
  report patches-affected-by-brush-shape-used-at-patch patch-under-brush
end

to-report patches-affected-by-brush-shape-used-at-patch [-patch]
  (ifelse
    brush-shape = "circle" [report patches-affected-by-a-circle-shaped-brush-at-patch -patch]
    brush-shape = "square" [report patches-affected-by-a-square-shaped-brush-at-patch -patch ] )
end

to-report patches-affected-by-a-circle-shaped-brush-at-patch [-patch]
  let radius (brush-size / 2)
  let -center-patch select-closest-patch-that-can-be-surrounded-by-radius-in-world -patch radius
  report [patches in-radius radius] of -center-patch
end

to-report select-closest-patch-that-can-be-surrounded-by-radius-in-world [-patch radius]
  let -pxcor [pxcor] of -patch
  let -pycor [pycor] of -patch
  let result-pxcor -pxcor
  let result-pycor -pycor

  let min-xcor (min-pxcor - 0.5)
  let max-xcor (max-pxcor + 0.5)
  let min-ycor (min-pycor - 0.5)
  let max-ycor (max-pycor + 0.5)

  let distance-from-min-xcor -pxcor - min-xcor
  let distance-from-max-xcor max-xcor - -pxcor
  let distance-from-min-ycor -pycor - min-ycor
  let distance-from-max-ycor max-ycor - -pycor

  if distance-from-min-xcor < radius [set result-pxcor min-xcor + radius]
  if distance-from-max-xcor < radius [set result-pxcor max-xcor - radius]
  if distance-from-min-ycor < radius [set result-pycor min-ycor + radius]
  if distance-from-max-ycor < radius [set result-pycor max-ycor - radius]

  report patch result-pxcor result-pycor
end

to-report patches-affected-by-a-square-shaped-brush-at-patch [-patch]
  let radius (brush-size / 2)
  let -center-patch select-closest-patch-that-can-be-surrounded-by-radius-in-world -patch radius
  ;report (patch-set n-values (brush-size ^ 2) [i -> patch (([pxcor] of -center-patch - (brush-size / 2) + 0.5) + i mod brush-size) (([pycor] of -center-patch - (brush-size / 2) + 0.5) + int(i / brush-size))])
  report (patch-set n-values (brush-size ^ 2) [i -> patch (([pxcor] of -center-patch - (brush-size / 2)) + i mod brush-size) (([pycor] of -center-patch - (brush-size / 2)) + int(i / brush-size))])
end

to-report patches-brush-is-drawing-on
    report patch-set [patches-affected-by-brush-shape-used-at-patch self] of patches-brush-moved-over-while-being-held-down
end

to-report patches-brush-moved-over-while-being-held-down
    ;report patches-line-intersects coordinates-of-brush-when-last-held-down mouse-coordinates
  report patches-line-intersects-no-wrap item 0 coordinates-of-brush-when-last-held-down item 1 coordinates-of-brush-when-last-held-down item 0 mouse-coordinates item 1 mouse-coordinates
end

to-report coordinates-of-brush-when-last-held-down
  report mousexy-when-brush-was-last-activated
  ;ifelse mouse-down?-when-brush-was-last-activated [report mousexy-when-brush-was-last-activated] [report mouse-coordinates]
end

to-report newly-drawn-on-patches-brush-is-drawing-on
  report patch-set patches-brush-is-drawing-on with [not member? self get-patches-drawn-on-since-brush-was-held-down]
end

to-report patch-under-brush
  report patch-at-point mouse-coordinates
end

to-report mouse-coordinates
  report current-mousexy
end

to set-brush-style-as-free-form
  set brush-style "free-form"
  on-user-set-brush-style-to-free-form
end

to set-brush-style-as-shape
  set brush-style "shape"
  on-user-set-brush-style-to-shape
end

to set-brush-shape [-brush-shape]
  set brush-shape -brush-shape
end

to set-shape-drawn-by-brush [-shape]
  set shape-drawn-by-brush -shape
end

to set-brush-type [-brush-type]
  set brush-type -brush-type
  on-brush-type-set
end

to on-brush-type-set
  update-brush-type-icon
end

to on-user-set-brush-style-to-shape
  ;set-brush-cursor-icon-to-draw
  update-brush-cursor-icon
  update-brush-draw-erase-icon
end

to on-user-set-brush-style-to-free-form
  update-brush-draw-erase-icon
  update-brush-cursor-icon
end

to-report brush-type-already-chosen [-brush-type]
  report brush-type = -brush-type
end

to toggle-add-erase
  set brush-in-draw-mode ifelse-value brush-in-draw-mode = true [false] [true]
end

to display-brush-border-outline
  ifelse show-brush-border? [
    show-brush-border-outline
    set-brush-border-outline-coordinates
    set-brush-border-outline-shape
    set-brush-border-outline-color
    set-brush-border-outline-size
    set-brush-border-outline-label ]
  [
    hide-brush-border-outline ]
end

to-report show-brush-border?
  report (brush-style = "free-form" and current-mouse-inside?)
end

to display-brush-cursor
  ifelse current-mouse-inside? [
    show-brush-cursor
    set-brush-cursor-coordinates ]
  [
    hide-brush-cursor ]
end

to update-brush-type-icon
  update-brush-type-icon-shape
  update-brush-type-icon-color
end

to update-brush-type-icon-shape
  carefully [
    ask brush-type-icon [set shape word "brush-type-icon-" brush-type] ]
  [
    ask brush-type-icon [set shape "full-square"]
  ]
end

to update-brush-type-icon-color
end

to set-brush-type-icon-color [-color]
  ask brush-type-icon [set color add-transparency -color brush-icon-transparency-normalized]
end

to update-brush-add-erase-mode-icon
  ifelse is-brush-in-draw-mode [
    set-brush-draw-erase-icon-to-draw ]
  [
    set-brush-draw-erase-icon-to-erase ]
end

to-report is-brush-in-draw-mode
  report (brush-in-draw-mode = true)
end

to-report is-brush-in-erase-mode
  report not is-brush-in-draw-mode
end

to-report add-transparency [-color transparency-normalized]
  let transparency (transparency-normalized * 255)
  (ifelse
    is-rgb -color [report add-transparency-rgb -color transparency]
    is-rgba -color [report add-transparency-rgba -color transparency]
  )
  report add-transparency-netlogo-color -color transparency
end

to-report is-rgb [-color]
  report (is-list? -color) and (length -color = 3)
end

to-report is-rgba [-color]
  report (is-list? -color) and (length -color = 4)
end

to-report add-transparency-rgb [-color transparency]
  report lput transparency -color
end

to-report add-transparency-rgba [-color transparency]
  report replace-item 3 -color transparency
end

to-report add-transparency-netlogo-color [-color transparency]
  report lput transparency extract-rgb -color
end

to-report rgba-to-hsb [-color]
  report extract-hsb sublist -color 0 3
end

to-report set-color-brightness [-color brightness-normalized]
  let brightness brightness-normalized * 100
  (ifelse
    is-rgb -color [report set-rgb-brightness -color brightness]
    is-rgba -color [report set-rgba-brightness -color brightness]
  )
  report set-netlogo-color-brightness -color brightness
end

to-report set-rgb-brightness [-color brightness]
  let -hsb extract-hsb -color
  let hue item 0 -hsb
  let saturation  item 1 -hsb
  report hsb hue saturation brightness
end

to-report set-rgba-brightness [-color brightness]
  let -hsb extract-hsb sublist -color 0 3
  let hue item 0 -hsb
  let saturation  item 1 -hsb
  let alpha item 3 -color
  report lput alpha hsb hue saturation brightness
end

to-report set-netlogo-color-brightness [-color brightness]
  let -hsb extract-hsb -color
  let hue item 0 -hsb
  let saturation  item 1 -hsb
  report approximate-hsb hue saturation brightness
end

to hide-brush-cursor
  ask -brush-cursor [hide-turtle]
end

to show-brush-cursor
  ask -brush-cursor [show-turtle]
end

to set-brush-cursor-coordinates
  (ifelse
    brush-style = "free-form" [set-brush-free-form-cursor-coordinates-and-heading]
    brush-style = "shape" [set-brush-shape-cursor-coordinates]
  )
end

to-report brush-cursor-near-top-right-corner-of-world
  report brush-cursor-near-right-edge-of-world and brush-cursor-near-top-edge-of-world
end

to-report brush-cursor-near-top-edge-of-world
  report last current-mousexy + [size / 2] of -brush-cursor > max-pycor - 0.35
end

to-report brush-cursor-near-right-edge-of-world
  report first current-mousexy + [size / 2] of -brush-cursor > max-pxcor - 0.35
end

to-report current-mouse-xcor
  report item 0 current-mousexy
end

to-report current-mouse-ycor
  report item 1 current-mousexy
end

to set-brush-free-form-cursor-coordinates-and-heading
  let new-heading 0
  let new-xcor current-mouse-xcor
  let new-ycor current-mouse-ycor
  (ifelse
    brush-cursor-near-top-right-corner-of-world [
      set new-heading 180
      set new-xcor current-mouse-xcor - 1.5
      set new-ycor current-mouse-ycor - 1.5
    ]
    brush-cursor-near-top-edge-of-world [
      set new-heading 90
      set new-xcor current-mouse-xcor + 1.5
      set new-ycor current-mouse-ycor - 1.5
    ]
    brush-cursor-near-right-edge-of-world [
      set new-heading 270
      set new-xcor current-mouse-xcor - 1.5
      set new-ycor current-mouse-ycor + 1.5
    ]
    [
      set new-heading 0
      set new-xcor current-mouse-xcor + 1.5
      set new-ycor current-mouse-ycor + 1.5
    ]
  )
  ask -brush-cursor [set heading new-heading]
  carefully [ ask -brush-cursor [set xcor new-xcor] ] []
  carefully [ ask -brush-cursor [set ycor new-ycor] ] []
end

to set-brush-shape-cursor-coordinates
  carefully [ ask -brush-cursor [set xcor ([pxcor] of patch-under-brush)]] []
  carefully [ ask -brush-cursor [set ycor ([pycor] of patch-under-brush)]] []
end

to display-brush-gfx
  display-brush-border-outline
  display-brush-cursor
  diplay-brush-xy-as-label-on-brush-mode-icon
  make-sure-brush-gets-updated-in-display-atleast-every 0.04
end

to make-sure-brush-gets-updated-in-display-atleast-every [seconds]
  if brush-activated-after-model-was-advanced [ every seconds [update-display] ]
  ;update-display-every-given-time-interval-if-ticks-have-not-advanced-since-brush-was-last-activated seconds
end

to diplay-brush-xy-as-label-on-brush-mode-icon
  ifelse current-mouse-inside? [
    ask brush-draw-erase-mode-icon [set label (word int item 0 current-mousexy ", " int item 1 current-mousexy) ] ]
  [
    ask brush-draw-erase-mode-icon [set label ""]
  ]
end

to set-brush-border-outline-label
  ;ask patch 0 min-pycor [set plabel brush-type]
end

to set-brush-border-outline-coordinates
  let radius (brush-size / 2)
  let -center-patch select-closest-patch-that-can-be-surrounded-by-radius-in-world patch-under-brush radius
  (ifelse
    brush-shape = "square" [ ;offset brush for even sizes since patch under brush can not be center
      carefully [
        ask -brush-border-outline [setxy ([pxcor] of -center-patch - 0.5 * ((brush-size + 1) mod 2)) ([pycor] of -center-patch - 0.5 * ((brush-size + 1) mod 2))]] [] ]
    brush-shape = "circle" [ask -brush-border-outline [setxy [pxcor] of -center-patch [pycor] of -center-patch]])
end

to hide-brush-border-outline
  ask -brush-border-outline [hide-turtle]
end

to show-brush-border-outline
  ask -brush-border-outline [show-turtle]
end

to set-brush-border-outline-shape
  (ifelse
    brush-shape = "square" [ask -brush-border-outline [set shape "square outline thick"] ]
    brush-shape = "circle" [ask -brush-border-outline [set shape "circle outline"] ])
end

to set-brush-border-outline-color
  ifelse is-brush-in-draw-mode [
    ask -brush-border-outline [set color cyan] ]
  [
    ask -brush-border-outline [set color red] ]
end

to set-brush-border-outline-size
  ask -brush-border-outline [set size brush-size]
end

to activate-brush
  set-brush-state
  display-brush-gfx
  draw-with-brush
  keep-track-of-current-brush-state
end

to set-brush-state
  set current-mousexy (list mouse-xcor mouse-ycor)
  set current-mouse-down? mouse-down?
  set current-mouse-inside? mouse-inside?
  if is-brush-pressed-down [set mouse-xy-when-brush-was-pressed-down current-mousexy]
end

to keep-track-of-current-brush-state
  update-which-patches-have-been-affected-by-brush-since-it-was-held-down
  set mouse-down?-when-brush-was-last-activated current-mouse-down?
  set mousexy-when-brush-was-last-activated current-mousexy
  set brush-activated-after-model-was-advanced true
end

to-report brush-is-held-down
  report current-mouse-down?
end

to update-which-patches-have-been-affected-by-brush-since-it-was-held-down
  ifelse brush-is-held-down [
    set patches-drawn-on-since-brush-was-held-down (patch-set patches-drawn-on-since-brush-was-held-down
      patches-brush-is-drawing-on) ]
  [
    set patches-drawn-on-since-brush-was-held-down no-patches ]
end

to-report is-brush-drawing-on-patches-not-drawn-on-since-brush-was-held-down
  report any? newly-drawn-on-patches-brush-is-drawing-on
end

to-report get-patches-drawn-on-since-brush-was-held-down
  report patches-drawn-on-since-brush-was-held-down
end

to user-set-brush-to-draw
  set brush-in-draw-mode true
  on-user-set-brush-to-draw
end

to user-set-brush-to-erase
  set brush-in-draw-mode false
  on-user-set-brush-to-erase
end

to on-user-set-brush-to-draw
  ;set-brush-draw-erase-icon-to-draw
  update-brush-draw-erase-icon
  set-brush-cursor-icon-to-draw
end

to on-user-set-brush-to-erase
  ;set-brush-draw-erase-icon-to-erase
  update-brush-draw-erase-icon
  set-brush-icon-to-erase
end

to update-brush-draw-erase-icon
  (ifelse
    brush-style = "shape" [set-brush-draw-erase-icon-as-current-shape-drawn-by-brush ]
    brush-style = "free-form" [set-brush-draw-erase-icon-for-free-form-brush ])
end

to set-brush-draw-erase-icon-as-current-shape-drawn-by-brush
  ask brush-draw-erase-mode-icon [set shape (word "brush-mode-icon-" shape-drawn-by-brush)]
end

to set-brush-draw-erase-icon-for-free-form-brush
  ifelse is-brush-in-draw-mode [set-brush-draw-erase-icon-to-draw] [set-brush-draw-erase-icon-to-erase]
end

to set-brush-cursor-icon-to-draw
  ask -brush-cursor [set shape "brush-cursor-draw6" set size 3]
end

to set-brush-icon-to-erase
  ask -brush-cursor [set shape "brush-cursor-erase" set size 3]
end

to set-brush-cursor-icon-to-shape-configure
  ask -brush-cursor [set shape "brush-cursor-shape" set size 4]
end

to update-brush-cursor-icon
  (ifelse
    brush-style = "shape" [set-brush-cursor-icon-to-shape-configure ]
    is-brush-in-draw-mode [set-brush-cursor-icon-to-draw ]
    [set-brush-icon-to-erase ] )
end

to set-brush-draw-erase-icon-to-draw
  ask brush-draw-erase-mode-icon [set shape "brush-mode-icon-draw2"]
end

to set-brush-draw-erase-icon-to-erase
  ask brush-draw-erase-mode-icon [set shape "brush-mode-icon-erase"]
end

;==== Brush functions unique to this model ======

to draw-shape-configured-by-brush
  if brush-type = "wall" [draw-shape-with-wall]
end

to draw-shape-with-wall
  create-wall-in-patches patches-affected-by-drawn-shape
end

to on-brush-is-held-down
  (ifelse
    brush-type = "ball" [on-brush-held-down-with-ball ]
    brush-type = "halo" [on-brush-held-down-with-halo ]
    brush-type = "trace" [on-brush-held-down-with-trace ]
    brush-type = "field" [on-brush-held-down-with-field] )
end

to on-brush-drawing-only-once-per-patch
  (ifelse
    brush-type = "wall" [on-brush-used-with-wall ]
    brush-type = "counter" [on-brush-used-with-counter ] )
end

to on-brush-has-been-clicked
  (ifelse
    brush-type = "ball" [on-brush-clicked-with-ball ]
    brush-type = "field" [on-brush-clicked-with-field ] )
  log-free-form-brush-used
end

to log-free-form-brush-used
  log-output (word ifelse-value is-brush-in-draw-mode ["paint-"] ["erase-"] brush-type)
end

to log-shape-drawn
  log-output (word "place-" shape-drawn-by-brush)
end

to on-brush-clicked-with-field
  ifelse is-brush-in-draw-mode [finalize-field-configuration-with-brush] [erase-field-number-under-brush]
end

to erase-field-number-under-brush
  if [has-field] of patch-under-brush [erase-field [field-number] of patch-under-brush]
end

to on-brush-held-down-with-field
  if is-brush-in-draw-mode [create-field-with-brush]
end

to create-field-with-brush
  ifelse is-brush-currently-configuring-a-field [
    configure-current-field-with-brush ]
  [
    configure-new-field-with-brush
  ]
end

to-report is-brush-currently-configuring-a-field
  report last-patch-brush-configured-field-on != nobody
end

to-report has-electric-field
  report field-number != 0
end

to configure-new-field-with-brush
  if not [has-wall] of patch-under-brush and not [has-electric-field] of patch-under-brush[
    set field-count field-count + 1
    set last-patch-brush-configured-field-on patch-under-brush
    set patches-field-drawn-on lput last-patch-brush-configured-field-on patches-field-drawn-on
    configure-current-field-with-brush
  ]
end

to-report is-first-patch-electric-field-drawn-on
  report length patches-field-drawn-on = 1
end

to-report before-last [-list]
  let -length length -list
  report item (-length - 2) -list
end

to configure-current-field-with-brush
  let field-x-value 0
  let field-y-value 0
  let prev-mouse-xcor item 0 mousexy-when-brush-was-last-activated
  let prev-mouse-ycor item 1 mousexy-when-brush-was-last-activated
  if patch-under-brush != last patches-field-drawn-on [
    set patches-field-drawn-on lput patch-under-brush patches-field-drawn-on]

  if not [has-wall] of patch-under-brush [
    ifelse is-first-patch-electric-field-drawn-on [
      set field-x-value (mouse-xcor - [pxcor] of patch-under-brush)
      set field-y-value (mouse-ycor - [pycor] of patch-under-brush)
    ] [
      set field-x-value (mouse-xcor - [pxcor] of before-last patches-field-drawn-on)
      set field-y-value (mouse-ycor - [pycor] of before-last patches-field-drawn-on)
    ]
    if (field-x-value != 0 or field-y-value != 0 ) [ ; mouse moved from prev location
      ask patch-under-brush [
        set field-number field-count
        set field-x field-x-value  / (sqrt ((field-x-value ^ 2) + (field-y-value ^ 2)))
        set field-y field-y-value  / (sqrt ((field-x-value ^ 2) + (field-y-value ^ 2)))
        draw-arrow-in-direction-of-electric-field
      ]
      ;paint-arrow this-patch
      set prev-mouse-xcor mouse-xcor
      set prev-mouse-ycor mouse-ycor
    ]
  ]
  set last-patch-brush-configured-field-on patch-under-brush
end

to finalize-field-configuration-with-brush
  if is-brush-currently-configuring-a-field [
    fill-field
    set patches-field-drawn-on []
    set last-patch-brush-configured-field-on nobody
    log-command "paint-field"
  ]
end

to-report balls-in-patches [-patches]
  report (turtle-set [balls-here] of patches-brush-is-drawing-on)
end

to-report balls-in-patches-brush-is-drawing-on
  report balls-in-patches patches-brush-is-drawing-on
end

to on-brush-used-with-counter
  if is-brush-pressed-down [
    set-counter-number-to-be-drawn-with-brush ]
  ifelse is-brush-in-draw-mode [create-counters-in-patches patches-brush-is-drawing-on] [remove-counters-from-patches patches-brush-is-drawing-on]
end

to remove-counters-from-patches [-patches]
  ask -patches [remove-counter-from-patch]
end

to create-counters-in-patches [-patches]
  ask -patches [create-counter-in-patch]
end

;patch procedure
to remove-counter-from-patch
  if has-counter [
    let counter-number-removed counter-number-here
    ask counters-here [die]
    on-counter-removed-from-patch counter-number-removed
  ]
end

to-report ball-count-in-population [population]
  report count balls-of population
end

to on-counter-removed-from-patch [counter-number-removed]
  update-position-of-counter-information counter-number-removed
end

to-report can-create-counter-in-patch
  report (not has-wall) and (not has-counter)
end

;patch procedure
to create-counter-in-patch
  if can-create-counter-in-patch [
    sprout-counters 1 [
      set shape  "square"
      set size counter-width
      ;set color counter-color
      ;let hsb-color extract-hsb item counter-number-drawn-by-brush base-colors
      ;set hsb-color replace-item 1 hsb-color 100
      ;set hsb-color replace-item 2 hsb-color 100
      set color (item ((counter-number-drawn-by-brush - 1) mod length default-colors-for-ball-populations) default-colors-for-ball-populations) + 2
      set counter-number counter-number-drawn-by-brush
      set heading 0
    ]
    on-counter-added-to-patch
  ]
end

;patch procedure
to-report counter-number-here
  report [counter-number] of one-of counters-here
end

to-report create-counter-number-gfx [-counter-number]
  let -counter-number-gfx sprout-initialized-gfx-overlay
  ask -counter-number-gfx [set label word "Area: " -counter-number]
  report -counter-number-gfx
end

to-report create-initialized-counter-information-gfx-overlay [-counter-number]
  let counter-information table:make
  table:put counter-information "counter-number" create-counter-number-gfx -counter-number
  table:put counter-information "ball-count" sprout-initialized-gfx-overlay
  report counter-information
end

to-report ball-count-in-counter [-counter-number]
  report table:get-or-default ball-count-in-counters -counter-number 0
end

to-report ball-count-gfx [-counter-number]
  report table:get get-counter-information -counter-number "ball-count"
end

to-report counter-number-gfx [-counter-number]
  report table:get get-counter-information -counter-number "counter-number"
end

to update-ball-count-in-counter [-counter-number]
  ask ball-count-gfx -counter-number [set label (word "Count: " ball-count-in-counter -counter-number)]
end

; patch procedure
to-report sprout-initialized-gfx-overlay
  let gfx-overlay-created nobody
  sprout-gfx-overlay 1 [set gfx-overlay-created self hide-turtle set shape "empty"]
  report gfx-overlay-created
end

to increase-counter [-counter-number]
  increment-table-value ball-count-in-counters -counter-number 1
  update-ball-count-in-counter -counter-number
end

to-report has-counter-been-initialized [-counter-number]
  report table:has-key? ball-count-in-counters -counter-number
end

to initialize-counter-information-if-not-initialized-yet [-counter-number]
  if not has-counter-been-initialized -counter-number [
    table:put counters-information-gfx-overlay -counter-number create-initialized-counter-information-gfx-overlay -counter-number
    table:put ball-count-in-counters -counter-number 0
    update-ball-count-in-counter -counter-number
  ]
end

;patch procedure
to on-counter-added-to-patch
  initialize-counter-information-if-not-initialized-yet counter-number-here
  update-position-of-counter-information counter-number-here
end

to-report counters-of [-counter-number]
  report counters with [counter-number = -counter-number]
end

to-report counters-with-counter-number-exist [-counter-number]
  report any? counters-of -counter-number
end

to-report get-counter-information [-counter-number]
  report table:get counters-information-gfx-overlay -counter-number
end

to hide-counter-information [-counter-number]
  ask counter-number-gfx -counter-number [hide-turtle]
  ask ball-count-gfx -counter-number [hide-turtle]
end

to-report center-turtle [-turtles]
  let mean-xcor mean [xcor] of -turtles
  let mean-ycor mean [ycor] of -turtles
  report min-one-of -turtles [distancexy mean-xcor mean-ycor]
end

to set-counter-information-in-center [-counter-number]
  let center-counter center-turtle counters-of -counter-number
  let center-counter-xcor [xcor] of center-counter
  let center-counter-ycor [ycor] of center-counter
  carefully [
    ask counter-number-gfx -counter-number [setxy center-counter-xcor center-counter-ycor show-turtle]
    ask ball-count-gfx -counter-number [setxy center-counter-xcor (center-counter-ycor - 1) show-turtle]
  ][]
end

to update-position-of-counter-information [-counter-number]
  ifelse not counters-with-counter-number-exist -counter-number [
    hide-counter-information -counter-number]
  [
    set-counter-information-in-center -counter-number
  ]
end

;patch procedure
to-report has-counter
  report count counters-here > 0
end

to-report counter-number-of-closest-neighbor-of-patches-brush-is-drawing-on-to-mouse-xy
  report 0
end

to-report highest-counter-number-in-use
  report max [counter-number] of counters
end

to-report highest-counter-number
  report max table:keys ball-count-in-counters
end

to-report any-counters-created-so-far
  report table:length ball-count-in-counters > 0
end

to-report new-highest-counter-number
  report ifelse-value any-counters-created-so-far [highest-counter-number + 1] [1]
end

to-report one-of-patches-brush-is-drawing-on-has-a-counter
  report count patches-brush-is-drawing-on with [has-counter] > 0
end

to-report counter-number-in-patch-brush-is-drawing-on-closest-to-mouse-xy
  report [counter-number-here] of min-one-of patches-brush-is-drawing-on with [has-counter] [distancexy item 0 current-mousexy item 1 current-mousexy]
end

to set-counter-number-to-be-drawn-with-brush
  ifelse one-of-patches-brush-is-drawing-on-has-a-counter [
    set counter-number-drawn-by-brush counter-number-in-patch-brush-is-drawing-on-closest-to-mouse-xy]
  [
    set counter-number-drawn-by-brush new-highest-counter-number
  ]
end

to on-brush-held-down-with-trace
  ifelse is-brush-in-draw-mode [trace balls-in-patches-brush-is-drawing-on] [stop-tracing balls-in-patches-brush-is-drawing-on]
end

to on-brush-held-down-with-halo
  ifelse is-brush-in-draw-mode [add-halo-to-balls balls-in-patches-brush-is-drawing-on] [remove-halo-from-balls balls-in-patches-brush-is-drawing-on]
end

to on-brush-clicked-with-ball
  if is-brush-in-draw-mode [create-balls-of-population-selected-in-ui]
end

to on-brush-held-down-with-ball
  if is-brush-in-erase-mode [remove-balls-from-patches-brush-is-drawing-on]
end

to remove-balls-from-patches-brush-is-drawing-on
  ask balls-in-patches-brush-is-drawing-on [remove-ball]
end

to create-balls-of-population-selected-in-ui
  if is-a-population-selected-in-ui [
    ;update-interactively-ball-population-property-settings
    create-balls-if-under-maximum-capacity population-to-set-properties-for-in-ui number-of-balls-to-add mouse-xcor mouse-ycor
  ]
end

to on-brush-used-with-wall
  ifelse is-brush-in-draw-mode [create-wall-in-patches patches-brush-is-drawing-on] [remove-wall-from-patches patches-brush-is-drawing-on]
end

to on-wall-brush-button-clicked
  if is-first-time-radio-button-is-activated "wall" [
    set-brush-type "wall"
    set-brush-style-as-free-form ]
  if should-release-brush-radio-button? "wall" [stop]
  activate-brush
end

to on-field-brush-button-clicked
  if is-first-time-radio-button-is-activated "field" [
    set-brush-type "field"
    set-brush-style-as-free-form
  ]
  if should-release-brush-radio-button? "field" [stop]
  activate-brush
end

to on-counter-brush-button-clicked
  if is-first-time-radio-button-is-activated "counter" [
    set-brush-type "counter"
    set-brush-style-as-free-form
  ]
  if should-release-brush-radio-button? "counter" [stop]
  activate-brush
end

to on-trace-brush-button-clicked
  if should-release-brush-radio-button? "trace" [stop]
  set-brush-type "trace"
  set-brush-style-as-free-form
  activate-brush
end

to on-halo-brush-button-clicked
  if should-release-brush-radio-button? "halo" [stop]
  set-brush-type "halo"
  set-brush-style-as-free-form
  activate-brush
end

to on-ball-brush-button-clicked
  if should-release-brush-radio-button? "ball" [stop]
  set-brush-type "ball"
  set-brush-style-as-free-form
  activate-brush
end

to on-wall-line-brush-button-clicked
  if should-release-brush-radio-button? "wall-line" [stop]
  set-brush-type "wall"
  set-shape-drawn-by-brush "line"
  set-brush-style-as-shape
  activate-brush
end

to on-wall-rectangle-brush-button-clicked
  if should-release-brush-radio-button? "wall-rectangle" [stop]
  set-brush-type "wall"
  set-shape-drawn-by-brush "rectangle"
  set-brush-style-as-shape
  activate-brush
end

to on-wall-circle-brush-button-clicked
  if should-release-brush-radio-button? "wall-circle" [stop]
  set-brush-type "wall"
  set-shape-drawn-by-brush "circle"
  set-brush-style-as-shape
  activate-brush
end

to on-wall-square-brush-button-clicked
  if is-first-time-radio-button-is-activated "wall-square" [
    set-brush-type "wall"
    set-shape-drawn-by-brush "square"
    set-brush-style-as-shape
  ]
  if should-release-brush-radio-button? "wall-square" [stop]
  activate-brush
end


;=========================

to create-wall-in-patches [-patches]
  foreach sort-patches-by-proximity-to-their-most-center-patch -patches [-patch -> ask -patch [create-wall-in-patch]]
end

to-report sort-patches-by-proximity-to-their-most-center-patch [-patches]
  let -center-patch center-agent-world-wrap -patches
  report sort-by [ [patch1 patch2] -> (distance-between-patches patch1 -center-patch) < (distance-between-patches patch2 -center-patch)] -patches
end

to-report distance-between-patches [patch1 patch2]
  report [distance patch2] of patch1
end

to-report center-agent-world-wrap [-patches]
  report min-one-of -patches [sum-distances-to-patches -patches]
end

;patch-procedure
to-report sum-distances-to-patches [-patches]
  let patch-to-calculate-distance-from self
  report sum [distance-between-patches patch-to-calculate-distance-from self] of -patches
end

to remove-wall-from-patches [-patches]
  ask -patches [remove-wall-in-patch]
end

;ball procedure
to-report has-halo
  report get-halo != nobody
end

;ball procedure
to-report get-halo
  let retreived-halo nobody
  let links-to-halos my-links with [is-halo? other-end]
  if any? links-to-halos [set retreived-halo [other-end] of one-of links-to-halos]
  report retreived-halo
end

;ball procedure
to remove-halo
  ask turtle-set ([other-end] of my-links with [is-halo? other-end]) [die]
end

;ball procedure
to remove-ball
  remove-halo
  kill-existing-compound-shapes
  ; ask a patch to kill ball so code can be executed after ball dies
  ask patch-here [
    ask myself [die]
    ; put any code here that needs to be executed after balls death
    update-ball-population-plot
  ]
end

to remove-halo-from-balls [-balls]
  ask -balls with [has-halo] [remove-halo]
end

to add-halo-to-balls [-balls]
  ask -balls with [not has-halo] [make-halo]
end

;turtle procedure
to trace [-turtles]
  ask -turtles [pen-down]
end

;turtle procedure
to stop-tracing [-turtles]
  ask -turtles [pen-up]
end

to-report patch-at-point [point]
  report patch first point last point
end

;===== INTERSECTION MATH ==================

to-report patches-line-intersects-no-wrap [x1 y1 x2 y2]
  let -start patch x1 y1
  let -stop patch x2 y2
  let neighbors-stop [neighbors-no-wrap] of -stop
  let result (patch-set -start)
  if -start != -stop [
    let -heading heading-between-points x1 y1 x2 y2
    let current-patch -start
    while [current-patch != -stop and not member? current-patch neighbors-stop] [
      set current-patch min-one-of ([neighbors-no-wrap with [not member? self result]] of current-patch)
      [abs (-heading - (heading-between-points x1 y1 pxcor pycor))]
      set result (patch-set result current-patch)
    ]
  ]
  report (patch-set result -stop)
end

to-report heading-between-points [x1 y1 x2 y2]
  report ((90 - atan (y2 - y1) (x2 - x1) ) mod 360)
end

;========= AST TREE ======================

to-report path-to-node-from-root [node]
  report reverse fput node-name node ancestors-names node
end

to-report ancestors-names [node]
  report map node-name ancestors-of node
end

to-report ancestors-of [node]
  let path-to-root []
  let curr-node node
  loop [
   set path-to-root lput curr-node path-to-root
   ifelse is-root-node curr-node [
     report but-first path-to-root
   ] [
     set curr-node node-parent curr-node
   ]
  ]
end

to-report first-node-by-name [name]
  report first filter [node -> node-name node = name] nodes-by-id
end

to-report node-name [node]
  report table:get node "name"
end

to-report node-id [node]
  report table:get node "id"
end

to-report node-parent [node]
  report item node-parent-id node nodes-by-id
end

to-report node-parent-id [node]
  report table:get node "parent-id"
end

to-report node-parameters [node]
  report table:get node "parameters"
end

to-report node-parameter [node parameter]
  report table:get node-parameters node parameter
end

to-report node-children [node]
  report table:get node "children"
end

to-report child-by-name [node name]
  report one-of filter [child -> node-name child = name] node-children node
end

to-report child-by-index [node index]
  report item index node-children node
end

to validate-node-has-only-children-named [node valid-names]
  let name node-name node
  let children node-children node
  let invalid-children filter [child -> not member? node-name child valid-names] children
  if not empty? invalid-children [
    let invalid-children-names map node-name invalid-children
    let message (word "'" name "' contains invalid block" ifelse-value length invalid-children-names = 1
      [(word ": '" first invalid-children-names "'")] [(word "s: " invalid-children-names)] )
    throw-ast-error first invalid-children message
  ]
end

to validate-node-has-exactly-n-children [node amount]
  let name node-name node
  let children node-children node
  let amount-of-children length children
  if amount-of-children != amount [
    let message (word "'" name "' needs to have exactly " amount
      " children. Current children count is " amount-of-children ": " children)
    throw-ast-error node message
  ]
end

to validate-only-one-of-children-exists [node names]
  let name node-name node
  let children node-children node
  let children-names map [child -> node-name child] children
  let name-intersection filter [element -> member? element children-names] (remove-duplicates names)
  let names-are-invalid length name-intersection > 1
  if names-are-invalid [
    let message (word "'" name "' can only have one of these blocks exist: " name-intersection)
    throw-ast-error node message
  ]
end

to validate-no-duplicate-children-named [node names]
  let name node-name node
  let children node-children node
  let children-names map node-name children
  let name-count table:counts children-names
  let duplicate-names filter [key -> table:get name-count key > 1] table:keys name-count
  if not empty? duplicate-names [
    let message (word "'" name "' can not have duplicate names: " duplicate-names)
    throw-ast-error node message
  ]
end

to validate-has-one-of-ancestors [node ancestors]
  let name node-name node
  let has-one-of-ancestors not empty? filter [ancestor -> member? ancestor ancestors] ancestors-names node
  if not has-one-of-ancestors [
    let message (word "'" name "' must be a descendent of: " ancestors)
    throw-ast-error node message
  ]
end

to reset-ast
  set ast-root table:make
  set current-node false
  set last-added-node false
  ;set nodes-by-id []
  ;set id-counter 0
end

to print-ast-nodes-parents
  foreach nodes-by-id [ node ->
    let name table:get node "name"
    let parent-name ""
    ifelse not is-root-node node [
      let parent-id table:get node "parent-id"
      let parent-node item parent-id nodes-by-id
      set parent-name table:get parent-node "name"
    ] [
      set parent-name "[root]"
    ]
    print (word name " " parent-name)
  ]
end

to print-path-to-node [src dest]
  let x string-builder-path-to-node src dest 0
  foreach x print
end

to-report string-path-to-node [src dest]
  let x string-builder-path-to-node src dest 0
  report reduce [[result next] -> (word result "\n" next)] x
end

to-report parameter-descriptor [node]
  let parameter-values table:values node-parameters node
  report ifelse-value not empty? parameter-values [
    reduce [[result next] -> (word result " " next)] parameter-values
  ] [
    "" ]
end

to-report string-builder-path-to-node [src dest indent]
  let path []
  let name node-name src
  let parameters node-parameters src
  let children node-children src
  let -parameter-descriptor parameter-descriptor src
  let src-descriptor ""
  ifelse src = dest [
    set src-descriptor (word char-repeat ">" (indent * 2) name " " -parameter-descriptor "\t <--- Error here!") ]
  [
    set src-descriptor (word char-repeat "." (indent * 4) name " " -parameter-descriptor) ]
  set path fput src-descriptor path
  foreach filter-nodes-above dest children [ child ->
    let child-descriptor string-builder-path-to-node child dest (indent + 1)
    foreach child-descriptor [x -> set path lput x path]
  ]
  report path
end

to-report filter-nodes-above [node other-nodes]
  let nodes-above []
  foreach other-nodes [ other-node ->
    set nodes-above lput other-node nodes-above
    if member? other-node ancestors-of node [report nodes-above]
  ]
  report nodes-above
end

to-report char-repeat [char -length]
  let string ""
  if -length > 0 [
    repeat -length [
      set string (word string char)
    ]
  ]
  report string
end

to-report is-root-node [node]
  report not table:has-key? node "parent-id"
end

to-report formula-to-atom-count-string [formula]
  let formula-atom-count count-atoms-in-chemical-formula formula
  let formula-string ""
  foreach formula-atom-count [atom-count -> set formula-string (word formula-string first atom-count last atom-count)]
  report formula-string
end

to-report is-chemical-equation-balanced [lhs rhs]
  let lhs-atom-count count-atoms-in-chemical-formula lhs
  let rhs-atom-count count-atoms-in-chemical-formula rhs
  report lhs-atom-count = rhs-atom-count
end

to-report count-atoms-in-chemical-formula [formula]
  let atom-count table:make
  foreach formula [compound -> count-atoms-in-compound compound atom-count]
  report sort-by [[count1 count2] -> first count1 < first count2] table:to-list atom-count
end

to throw-ast-error [node message]
  let x (word "Error parsing node '" node-name node "'\n" message "\n")
    ;"Path to block: " reduce [[result next] -> (word result " -> " next)] path-to-node-from-root node)
  set x (word x "\n" string-path-to-node table:get ast-by-population 1 node)
  error x
end

to count-atoms-in-compound [compound atom-count]
  let coefficient first compound
  let elemental-molecules-in-compound but-first compound
  foreach elemental-molecules-in-compound [elemental-molecule ->
    let element first elemental-molecule
    let amount last elemental-molecule
    let element-count-in-compound coefficient * amount
    increment-table-value atom-count element element-count-in-compound
  ]
end

to increment-table-value [dict key increment]
  let value table:get-or-default dict key 0
  table:put dict key value + increment
end

to-report last-n-elements [-list n]
  let -length length -list
  report ifelse-value n < -length [sublist -list (-length - n) -length] [-list]
end

to-report tables-are-equal [t1 t2]
  report table-as-list t1 = table-as-list t2
end

to-report table-as-list [element]
  (ifelse
    is-table element [report map [key -> (list key (table-as-list table:get element key))] table:keys element ]
    is-list? element [report map [list-element -> table-as-list list-element] element]
    [report element]
  )
end

to-report is-table [t]
  ; this procedure is not correct but we currently assume that an element in a table can only be
  ; one of 5 values: table, string, number, list or boolean
  ; need to check if there is a way to get object type
  report (not is-string? t) and (not is-number? t) and (not is-list? t) and (not is-boolean? t)
end

to-report is-table2 [t]
  ; this procedure runs extremely slow
  let -is-table false
  carefully [
    let x table:has-key? t "1"
    set -is-table true ]
  [ ]
  report -is-table
end

to-report copy-table [orig]
  let copy table:make
  foreach (table:keys orig) [key -> table:put copy key (table:get orig key)]
  report copy
end

to increase-depth
  set current-node last-added-node
end

to decrease-depth
  set current-node get-parent-node current-node
end

to-report get-parent-node [node]
  let parent-id table:get node "parent-id"
  report item parent-id nodes-by-id
end

to add-node [name parameters]
  let node create-node name parameters
  ifelse is-ast-empty [
    set-as-root-node-in-ast node
  ] [
    add-child-to-currently-selected-node node
  ]
  set last-added-node node
end

to set-as-root-node-in-ast [node]
  set ast-root node
  set current-node node
end

to-report create-node [name parameters]
  let node table:from-list (list
    (list "id" id-counter)
    (list "name" name)
    (list "parameters" table:from-list parameters)
    (list "children" [])
  )
  set nodes-by-id lput node nodes-by-id
  set id-counter id-counter + 1
  report node
end

to-report is-ast-empty
  report table:length ast-root = 0
end

to add-child-to-currently-selected-node [node]
  table:put node "parent-id" table:get current-node "id"
  let updated-children lput node table:get current-node "children"
  table:put current-node "children" updated-children
end

; --- NETTANGO BEGIN ---

; This block of code was added by the NetTango builder.  If you modify this code
; and re-import it into the NetTango builder you may lose your changes or need
; to resolve some errors manually.

; If you do not plan to re-import the model into the NetTango builder then you
; can safely edit this code however you want, just like a normal NetLogo model.

; Code for Population 1
to configure-population-1
  reset-ast
  add-node "configure-population" (list (list "population" 1))
add-node "properties" []
increase-depth if true [
  add-node "name" (list (list "name" "H2"))
  add-node "color" (list (list "color" (15)))
  add-node "shape" (list (list "shape" "molecule-a2"))
  add-node "size" (list (list "size" 2.2))
  add-node "initial-heading" (list (list "heading" "random"))
  add-node "initial-speed" (list (list "speed" 15))
] decrease-depth
add-node "actions" []
increase-depth if true [
  add-node "move-forever" []
] decrease-depth
add-node "interactions" []
increase-depth if true [
  add-node "if-ball-meets" []
  increase-depth
  add-node "objects" []
  increase-depth if true [
    add-node "wall" []
  ] decrease-depth
  add-node "then" []
  increase-depth if true [
    add-node "heading" (list (list "heading" "collide"))
    add-node "speed" (list (list "speed" "collide"))
  ] decrease-depth
  decrease-depth
] decrease-depth
table:put curr-ast-by-population 1 ast-root
end
; --- NETTANGO END ---
@#$#@#$#@
GRAPHICS-WINDOW
201
10
713
523
-1
-1
9.51
1
11
1
1
1
0
1
1
1
-26
26
-26
26
1
1
1
ticks
30.0

SLIDER
800
273
939
306
number-of-balls-to-add
number-of-balls-to-add
1
100
11.0
1
1
NIL
HORIZONTAL

BUTTON
32
10
149
56
Reset
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
422
539
513
572
play
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
101
61
181
121
Set
paint-world
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
6
120
192
142
-------------------------------------
14
0.0
1

BUTTON
942
273
1002
306
Erase All
erase-all-balls-of-population-selected-in-ui
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
267
539
364
572
save model 
save-existing-layout
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
568
539
663
572
load model
load-existing-layout
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
726
85
851
118
Color-Speed
Color-Speed
1
1
-1000

INPUTBOX
0
61
97
121
background-color
0.0
1
0
Color

MONITOR
887
220
950
265
Amount
count balls with [population-num = population-to-set-properties-for-in-ui]
17
1
11

BUTTON
26
167
91
200
Draw
user-set-brush-to-draw
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
98
167
168
200
Erase
user-set-brush-to-erase\nset-brush-style-as-free-form
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
26
208
168
241
brush-size
brush-size
1
10
3.0
1
1
NIL
HORIZONTAL

BUTTON
26
247
94
280
Circle
set-brush-shape \"circle\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
102
247
170
280
Square
set-brush-shape \"square\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
7
317
95
350
Wall
on-wall-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
6
506
95
539
Circle
on-wall-circle-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
100
506
189
539
Square
on-wall-square-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
6
357
95
390
Counter
on-counter-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
100
318
191
351
Field
on-field-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
722
273
796
306
Add Balls
on-ball-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
6
397
95
430
Halo
on-halo-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
100
356
189
389
Trace
on-trace-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
75
143
126
177
Brush
14
0.0
1

TEXTBOX
53
293
151
311
Brush Pallete
14
0.0
1

TEXTBOX
788
177
865
195
Ball Pallete
14
0.0
1

BUTTON
6
468
95
501
Line
on-wall-line-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
100
468
189
501
Rectangle
on-wall-rectangle-brush-button-clicked
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
56
444
135
462
Wall Shape
14
0.0
1

INPUTBOX
53
549
131
609
wall-color
105.0
1
0
Color

SWITCH
726
46
892
79
flash-wall-collision
flash-wall-collision
1
1
-1000

MONITOR
803
220
876
265
Population
ifelse-value pprop population-to-set-properties-for-in-ui \"name\" != \"\" [pprop population-to-set-properties-for-in-ui \"name\"] [population-to-set-properties-for-in-ui]
17
1
11

BUTTON
723
220
790
265
Next
select-next-population-in-properties-ui
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
795
19
822
37
SFX
14
0.0
1

TEXTBOX
750
201
897
220
Select population to add balls
11
0.0
1

SWITCH
891
558
996
591
log-enabled
log-enabled
1
1
-1000

MONITOR
724
551
796
596
Population 1
table:get-or-default wall-collision-count 1 0
17
1
11

TEXTBOX
762
522
896
547
Wall Collisions
14
0.0
1

MONITOR
803
551
878
596
Population 2
table:get-or-default wall-collision-count 1 0
17
1
11

SWITCH
726
125
845
158
show-name
show-name
1
1
-1000

PLOT
721
326
1002
513
Ball Population
Time
Population
0.0
10.0
0.0
10.0
true
false
"" ""
PENS

BUTTON
434
577
501
610
Step
go\nupdate-display-every-n-ticks 1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

ball
true
0
Circle -7500403 true true 90 90 120
Circle -16777216 false false 90 90 120

battery
false
9
Rectangle -7500403 true false 14 90 284 210
Rectangle -2674135 true false 255 90 285 210
Rectangle -2674135 true false 30 90 30 210
Rectangle -16777216 true false 15 90 45 210
Rectangle -13791810 false true 164 151 195 147
Rectangle -1 true false 25 137 31 161
Rectangle -1 true false 259 141 280 148
Rectangle -1 true false 18 146 40 153

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

brush-cursor-draw6
true
7
Polygon -1184463 true false 195 45 225 45 255 75 255 105 75 270 75 240 45 210 45 210 15 210 195 45
Polygon -16777216 false false 15 210 195 45 225 45 255 75 255 105 75 270 75 240 45 210 15 210
Line -16777216 false 225 45 45 210
Line -16777216 false 255 75 75 240
Polygon -2674135 true false 45 195 15 270
Polygon -2674135 true false 15 210 0 285 75 270 75 240 45 210 15 210
Polygon -16777216 false false 15 210 0 285 75 270 75 240 45 210 15 210

brush-cursor-erase
false
0
Polygon -16777216 false false 75 195
Polygon -2064490 true false 30 270 135 270 240 165 225 120 135 120 45 195 30 270
Line -16777216 false 30 270 135 270
Line -16777216 false 135 195 135 270
Line -16777216 false 135 270 240 165
Line -16777216 false 240 165 225 120
Line -16777216 false 135 195 225 120
Line -16777216 false 45 195 135 195
Line -16777216 false 45 195 30 270
Line -16777216 false 45 195 135 120
Line -16777216 false 135 120 225 120

brush-cursor-shape
false
0
Circle -13840069 true false 116 116 67
Rectangle -13840069 true false 138 143 243 158
Rectangle -13840069 true false 46 143 151 158
Rectangle -13840069 true false 142 43 157 148
Rectangle -13840069 true false 143 146 158 251
Circle -16777216 true false 128 128 44

brush-cursor-shape3
false
0
Rectangle -13840069 true false 125 126 132 176
Rectangle -13840069 true false 125 169 177 176
Rectangle -13840069 true false 170 125 178 176
Rectangle -13840069 true false 125 125 177 132
Rectangle -13840069 true false 171 146 220 154
Rectangle -13840069 true false 82 146 131 154
Rectangle -13840069 true false 147 80 155 129
Rectangle -13840069 true false 147 170 155 219

brush-mode-icon-circle
false
7
Rectangle -7500403 true false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Circle -13791810 true false 23 26 254
Circle -7500403 true false 45 49 210
Rectangle -16777216 false false 0 0 300 300

brush-mode-icon-draw-circle
false
7
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Circle -13345367 true false -2 -2 302
Circle -7500403 true false 30 30 240
Polygon -1184463 true false 210 30 240 30 270 60 270 90 90 255 90 225 60 195 60 195 30 195 210 30
Polygon -16777216 false false 30 195 210 30 240 30 270 60 270 90 90 255 90 225 60 195 30 195
Line -16777216 false 240 30 60 195
Line -16777216 false 270 60 90 225
Polygon -2674135 true false 45 195 15 270
Polygon -2674135 true false 30 195 15 270 90 255 90 225 60 195 30 195
Polygon -16777216 false false 30 195 15 270 90 255 90 225 60 195 30 195

brush-mode-icon-draw-circle3
false
5
Rectangle -7500403 true false 0 0 300 300
Circle -13345367 true false 23 23 255
Circle -7500403 true false 45 45 210
Rectangle -16777216 false false 0 0 300 300

brush-mode-icon-draw2
false
7
Rectangle -7500403 true false 0 0 300 300
Polygon -1184463 true false 210 30 240 30 270 60 270 90 90 255 90 225 60 195 60 195 30 195 210 30
Polygon -16777216 false false 30 195 210 30 240 30 270 60 270 90 90 255 90 225 60 195 30 195
Line -16777216 false 240 30 60 195
Line -16777216 false 270 60 90 225
Polygon -2674135 true false 45 195 15 270
Polygon -2674135 true false 30 195 15 270 90 255 90 225 60 195 30 195
Polygon -16777216 false false 30 195 15 270 90 255 90 225 60 195 30 195
Rectangle -16777216 false false 0 0 300 300

brush-mode-icon-erase
false
6
Rectangle -7500403 true false 0 0 300 300
Polygon -16777216 false false 75 195
Polygon -2064490 true false 45 225 150 225 255 120 240 75 150 75 60 150 45 225
Line -16777216 false 45 225 150 225
Line -16777216 false 150 150 150 225
Line -16777216 false 150 225 255 120
Line -16777216 false 255 120 240 75
Line -16777216 false 150 150 240 75
Line -16777216 false 60 150 150 150
Line -16777216 false 60 150 45 225
Line -16777216 false 60 150 150 75
Line -16777216 false 150 75 240 75
Rectangle -16777216 false false 0 0 300 300

brush-mode-icon-line
false
7
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Polygon -13791810 true false 46 246 241 36 256 51 61 261 46 246

brush-mode-icon-rectangle
false
7
Rectangle -7500403 true false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Rectangle -13791810 true false 23 80 278 230
Rectangle -7500403 true false 42 100 259 209
Rectangle -16777216 false false 0 0 300 300

brush-mode-icon-square
false
7
Rectangle -7500403 true false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Rectangle -13791810 true false 40 41 268 268
Rectangle -7500403 true false 68 70 239 241
Rectangle -16777216 false false 0 0 300 300

brush-type-icon-ball
false
9
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Circle -16777216 true false 93 89 118
Circle -955883 true false 94 90 116

brush-type-icon-ball2
false
15
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Circle -1184463 false false 41 42 220
Circle -11221820 true false 124 19 50
Circle -955883 true false 92 88 120
Circle -11221820 true false 40 187 50
Circle -11221820 true false 213 186 50

brush-type-icon-counter
false
7
Rectangle -7500403 true false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Line -16777216 false 60 0 60 300
Line -16777216 false 240 0 240 315
Line -16777216 false 0 60 315 60
Line -16777216 false 0 240 300 240
Rectangle -13840069 true false 139 152 159 219
Rectangle -13840069 true false 124 219 174 235
Polygon -13840069 true false 159 137 125 162 125 184 159 163
Rectangle -13840069 true false 65 190 116 205
Rectangle -13840069 true false 83 173 98 223
Circle -16777216 true false 147 52 85
Circle -955883 true false 148 53 83
Line -16777216 false 172 33 154 18
Line -16777216 false 136 45 105 20
Line -16777216 false 122 83 107 73

brush-type-icon-field
false
7
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Polygon -13345367 true false 60 195 180 195 180 150 256 216 180 285 180 240 180 240 60 240 60 195
Line -16777216 false 45 60 75 60
Line -16777216 false 90 60 135 60
Line -16777216 false 135 60 150 60
Circle -955883 true false 158 42 94
Line -16777216 false 135 90 120 90
Line -16777216 false 147 120 105 120
Line -16777216 false 90 120 60 120
Line -16777216 false 60 90 30 90
Line -16777216 false 105 90 60 90
Line -16777216 false 50 120 40 120

brush-type-icon-halo
false
9
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Circle -16777216 true false 93 89 118
Circle -955883 true false 94 90 116
Circle -1184463 false false 33 33 234

brush-type-icon-halo2
false
9
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Circle -16777216 true false 88 84 128
Circle -955883 true false 89 85 126
Circle -1184463 false false 32 31 238

brush-type-icon-trace
false
9
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Polygon -13840069 true false 150 165 191 253 228 209 255 270 245 275 270 285 272 258 262 264 232 194 193 237 157 160
Circle -16777216 true false 87 83 110
Circle -955883 true false 88 84 108

brush-type-icon-trace3
false
9
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 false false 0 0 300 300
Polygon -2674135 true false 45 195 15 270
Polygon -2674135 true false 132 150 174 247 218 191 258 263 249 271 273 280 276 252 266 259 220 170 176 225 143 142
Circle -16777216 true false 63 58 128
Circle -955883 true false 64 59 126

brush-type-icon-wall
false
6
Rectangle -1 true false 0 0 300 300
Rectangle -13345367 true false 15 225 150 285
Rectangle -13345367 true false 165 225 300 285
Rectangle -13345367 true false 75 150 210 210
Rectangle -13345367 true false 0 150 60 210
Rectangle -13345367 true false 225 150 300 210
Rectangle -13345367 true false 166 75 301 135
Rectangle -13345367 true false 15 75 150 135
Rectangle -13345367 true false 0 0 60 60
Rectangle -13345367 true false 225 0 300 60
Rectangle -13345367 true false 75 0 210 60
Polygon -6459832 true false 123 155 207 261 221 265 234 251 235 238 147 136 123 155
Polygon -7500403 true false 140 147 155 133 149 116 150 109 154 104 168 97 190 91 179 78 154 82 127 93 101 111 88 122 92 129 93 131 91 135 87 136 83 134 78 129 59 145 57 157 78 181 88 187 109 168 104 161 103 154 105 155 105 152 105 152 112 155 116 161
Polygon -16777216 false false 178 79 188 90 152 104 149 108 149 117 155 133 147 139 130 152 115 161 111 154 104 153 102 156 108 167 88 187 78 181 56 155 59 146 76 129 85 137 89 139 92 131 88 122 129 91 156 82 176 78
Polygon -16777216 false false 150 138 234 238 234 252 220 263 206 260 125 157
Rectangle -16777216 false false 0 0 300 300

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

circle outline
true
0
Circle -7500403 false true 0 0 300

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

empty
false
0

eraser
false
0
Rectangle -7500403 true true 0 0 300 360
Rectangle -7500403 true true 0 0 300 375

face happy
true
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

full-square
false
0
Rectangle -7500403 true true 0 0 300 300

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

magnet
true
0
Polygon -7500403 true true 120 270 75 270 60 105 60 60 75 30 106 10 150 3 195 10 225 30 240 60 240 105 225 270 180 270 195 105 196 74 184 55 165 45 135 45 115 55 104 75 105 105
Polygon -16777216 true false 219 264 188 264 193 214 224 215
Polygon -16777216 true false 81 264 112 264 107 214 76 215

minus
true
15
Line -7500403 false 165 135 135 135

molecule-a2
true
0
Circle -7500403 true true 136 66 158
Circle -16777216 false false 136 66 158
Circle -7500403 true true 5 67 158
Circle -16777216 false false 4 67 160

molecule-a2-static
true
0
Circle -13791810 true false 136 66 158
Circle -16777216 false false 136 66 158
Circle -13791810 true false 5 67 158
Circle -16777216 false false 4 67 160

molecule-ab2
true
0
Circle -1 true false 183 63 84
Circle -16777216 false false 183 63 84
Circle -7500403 true true 75 75 150
Circle -16777216 false false 75 75 150
Circle -1 true false 33 63 84
Circle -16777216 false false 33 63 84

molecule-ab2-a
true
0
Circle -7500403 true true 75 75 150
Circle -16777216 false false 75 75 150

molecule-ab2-b2
true
0
Circle -7500403 true true 183 63 84
Circle -16777216 false false 183 63 84
Circle -7500403 true true 33 63 84
Circle -16777216 false false 33 63 84

molecule-alcohol
true
6
Circle -7500403 true false 160 106 88
Circle -16777216 false false 159 105 90
Circle -7500403 true false 106 106 88
Circle -16777216 false false 105 105 90
Circle -2674135 true false 54 106 88
Circle -16777216 false false 53 105 90
Circle -1 true false -1 105 88
Circle -16777216 false false -2 104 90
Circle -1 true false 89 192 88
Circle -16777216 false false 88 191 90
Circle -1 true false 213 107 88
Circle -1 true false 86 21 88
Circle -1 true false 174 20 88
Circle -1 true false 176 192 88
Circle -16777216 false false 173 19 90
Circle -16777216 false false 85 20 90
Circle -16777216 false false 175 191 90
Circle -16777216 false false 212 106 90

molecule-alcohol-c2
true
0
Circle -7500403 true true 160 106 88
Circle -16777216 false false 159 105 90
Circle -7500403 true true 106 106 88
Circle -16777216 false false 105 105 90

molecule-alcohol-h5
true
0
Circle -7500403 true true -1 105 88
Circle -16777216 false false -2 104 90
Circle -7500403 true true 89 192 88
Circle -16777216 false false 88 191 90
Circle -7500403 true true 213 107 88
Circle -7500403 true true 86 21 88
Circle -7500403 true true 174 20 88
Circle -7500403 true true 176 192 88
Circle -16777216 false false 173 19 90
Circle -16777216 false false 85 20 90
Circle -16777216 false false 175 191 90
Circle -16777216 false false 212 106 90

molecule-alcohol-oh
true
0
Circle -7500403 true true 54 106 88
Circle -16777216 false false 53 105 90

molecule-ao
true
0
Circle -2674135 true false 136 66 158
Circle -16777216 false false 136 66 158
Circle -8630108 true false 5 67 158
Circle -16777216 false false 4 67 160

molecule-ao-a
true
0
Circle -7500403 true true 5 67 158
Circle -16777216 false false 4 67 160

molecule-ao-o
true
0
Circle -7500403 true true 136 66 158
Circle -16777216 false false 136 66 158

molecule-candle
true
4
Circle -7500403 true false 73 103 95
Circle -16777216 false false 73 103 96
Circle -7500403 true false 133 103 95
Circle -16777216 false false 133 103 96
Circle -1 true false 141 182 95
Circle -16777216 false false 140 182 96
Circle -1 true false 136 25 95
Circle -16777216 false false 136 24 96
Circle -1 true false -2 103 95
Circle -1 true false 208 103 95
Circle -1 true false 69 26 95
Circle -1 true false 67 182 95
Circle -16777216 false false 69 25 96
Circle -16777216 false false 208 102 96
Circle -16777216 false false -2 103 96
Circle -16777216 false false 67 182 96

molecule-candle-c
true
0
Circle -955883 true false 73 103 95
Circle -16777216 false false 73 103 96
Circle -955883 true false 133 103 95
Circle -16777216 false false 133 103 96

molecule-candle-h
true
0
Circle -13840069 true false 141 182 95
Circle -16777216 false false 140 182 96
Circle -13840069 true false 136 25 95
Circle -16777216 false false 136 24 96
Circle -13840069 true false -2 103 95
Circle -13840069 true false 208 103 95
Circle -13840069 true false 69 26 95
Circle -13840069 true false 67 182 95
Circle -16777216 false false 69 25 96
Circle -16777216 false false 208 102 96
Circle -16777216 false false -2 103 96
Circle -16777216 false false 67 182 96

molecule-ch4
true
6
Circle -13840069 true true 36 20 230
Circle -16777216 false false 35 19 232
Circle -1 true false 206 136 92
Circle -1 true false 1 136 92
Circle -1 true false 109 207 92
Circle -16777216 false false 0 135 94
Circle -16777216 false false 205 135 94
Circle -16777216 false false 108 207 94
Circle -1 true false 105 1 92
Circle -16777216 false false 104 0 94

molecule-ch4-c
true
0
Circle -7500403 true true 36 20 230
Circle -16777216 false false 35 19 232

molecule-ch4-h4
true
0
Circle -7500403 true true 206 136 92
Circle -7500403 true true 1 136 92
Circle -7500403 true true 109 207 92
Circle -16777216 false false 0 135 94
Circle -16777216 false false 205 135 94
Circle -16777216 false false 108 207 94
Circle -7500403 true true 105 1 92
Circle -16777216 false false 104 0 94

molecule-co2
true
5
Circle -2674135 true false 162 81 138
Circle -2674135 true false 0 84 138
Circle -16777216 false false -1 83 140
Circle -16777216 false false 161 81 140
Circle -7500403 true false 82 86 138
Circle -16777216 false false 81 85 140

molecule-co2-c
true
0
Circle -7500403 true true 82 86 138
Circle -16777216 false false 81 85 140

molecule-co2-o2
true
0
Circle -7500403 true true 162 81 138
Circle -7500403 true true 0 84 138
Circle -16777216 false false -1 83 140
Circle -16777216 false false 161 81 140

molecule-h2o
true
4
Circle -1 true false 186 162 112
Circle -1 true false 3 167 112
Circle -16777216 false false 3 167 113
Circle -16777216 false false 185 162 113
Circle -2674135 true false 46 6 210
Circle -16777216 false false 46 5 211

molecule-h2o-h2
true
0
Circle -7500403 true true 186 162 112
Circle -7500403 true true 3 167 112
Circle -16777216 false false 3 167 113
Circle -16777216 false false 185 162 113

molecule-h2o-o
true
0
Circle -7500403 true true 46 6 210
Circle -16777216 false false 46 5 211

molecule-ha
true
6
Circle -1184463 true false 40 44 252
Circle -16777216 false false 39 44 254
Circle -1 true false 3 2 112
Circle -16777216 false false 3 2 112

molecule-ha-a
true
0
Circle -7500403 true true 3 2 112
Circle -16777216 false false 3 2 112

molecule-ha-h
true
0
Circle -7500403 true true 40 44 252
Circle -16777216 false false 39 44 254

molecule-nh3
true
6
Circle -13840069 true true 36 5 230
Circle -16777216 false false 35 4 232
Circle -1 true false 208 129 92
Circle -1 true false 0 127 92
Circle -1 true false 109 207 92
Circle -16777216 false false -1 126 94
Circle -16777216 false false 208 129 94
Circle -16777216 false false 108 207 94

molecule-nh3-h3
true
0
Circle -7500403 true true 208 129 92
Circle -7500403 true true 0 127 92
Circle -7500403 true true 109 207 92
Circle -16777216 false false -1 126 94
Circle -16777216 false false 208 129 94
Circle -16777216 false false 108 207 94

molecule-nh3-n
true
0
Circle -7500403 true true 36 5 230
Circle -16777216 false false 35 4 232

molecule-no2
true
0
Circle -2674135 true false 162 111 138
Circle -2674135 true false 0 114 138
Circle -16777216 false false -1 113 140
Circle -16777216 false false 161 111 140
Circle -8630108 true false 82 26 138
Circle -16777216 false false 81 25 140

molecule-no2-n
true
0
Circle -7500403 true true 82 26 138
Circle -16777216 false false 81 25 140

molecule-no2-o2
true
0
Circle -7500403 true true 162 111 138
Circle -7500403 true true 0 114 138
Circle -16777216 false false -1 113 140
Circle -16777216 false false 161 111 140

molecule-sugar
true
0
Polygon -7500403 true true 90 15 210 15 285 90 285 210 210 285 90 285 15 210 15 90 90 15
Polygon -16777216 false false 90 15 210 15 285 90 285 210 210 285 90 285 15 210 15 90 90 15

molecule-sugar-static
true
0
Polygon -1184463 true false 90 15 210 15 285 90 285 210 210 285 90 285 15 210 15 90 90 15
Polygon -16777216 false false 90 15 210 15 285 90 285 210 210 285 90 285 15 210 15 90 90 15

orbit 1
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 false true 41 41 218

orbit 2
true
0
Circle -7500403 true true 116 221 67
Circle -7500403 true true 116 11 67
Circle -7500403 false true 44 44 212

orbit 3
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 true true 26 176 67
Circle -7500403 true true 206 176 67
Circle -7500403 false true 45 45 210

outside
true
0
Circle -13840069 true false -166 -121 212

pencil
false
0
Polygon -7500403 true true 255 60 255 90 105 240 90 225
Polygon -7500403 true true 60 195 75 210 240 45 210 45
Polygon -7500403 true true 90 195 105 210 255 60 240 45
Polygon -6459832 true false 90 195 60 195 45 255 105 240 105 210
Polygon -16777216 true false 45 255 74 248 75 240 60 225 51 225

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

plus
false
15
Line -7500403 false 150 0 150 300
Line -7500403 false 300 165 0 165
Line -7500403 false 300 165 0 165
Line -7500403 false 300 165 0 165
Line -7500403 false 300 165 0 165
Line -7500403 false 150 0 150 300
Line -7500403 false 150 0 150 300

square
true
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

square full
false
0
Rectangle -7500403 true true 0 0 300 300

square outline
false
0
Rectangle -7500403 false true 0 0 300 300

square outline thick
false
0
Rectangle -7500403 true true 0 285 300 300
Rectangle -7500403 true true 285 0 300 300
Rectangle -7500403 true true 0 0 300 15
Rectangle -7500403 true true 0 0 15 300

square-outline
false
6
Rectangle -13840069 false true 0 0 300 300

star
true
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

thin ring
true
0
Circle -7500403 false true -1 -1 301

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
