text = (x) ->
    $("#numericjs").html numeric.prettyPrint x
    
plot = (x, y, params...) ->
    $.plot $("#flot"), [numeric.transpose([x, y])], params...

class Slider

    constructor: (@spec) ->
        @slider = @spec.slider
        @setText()
        @slider.unbind "change"
        @slider.change => @change()

    val: -> @slider.val()

    setText: -> @spec.text.html @val()

    change: ->
        @setText()
        @spec.change @val()

class SineWave
    
    linspace = numeric.linspace
    add = numeric.add
    mul = numeric.mul
    sin = numeric.sin
    
    constructor: (@spec) ->
        @x = linspace @spec.xMin, @spec.xMax, @spec.numPoints
        @freq = @spec.freq
        @noiseVar = @spec.noiseVar
        @plot()
        
    setFreq: (@freq) -> @plot()
        
    setNoise: (@noiseVar) -> @plot()
        
    plot: ->
        @y = sin mul(2*Math.PI*@freq, @x)
        @y = (add(y, @noise()) for y in @y)
        plot @x, @y,
            xaxis: {min: @spec.xMin, max: @spec.xMax}
            yaxis: {min: -1.5, max: 1.5}
            series: {color: "#55f"}
            
    noise: (v) -> Math.sqrt(12*@noiseVar)*(Math.random()-0.5)
        
freq = new Slider
    slider: $ "#frequency"
    text: $ "#freq_number"
    change: (f) ->
        sine.setFreq f
        dispText()
        
noise = new Slider
    slider: $ "#noise"
    text: $ "#noise_number"
    change: (v) ->
        sine.setNoise v
        dispText()

spec =
    xMin: 0
    xMax: 1
    numPoints: 1000
    freq: freq.val()
    noiseVar: noise.val()

sine = new SineWave spec
dispText = -> text sine.y[0..5]    
dispText()


