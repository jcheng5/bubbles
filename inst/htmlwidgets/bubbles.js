HTMLWidgets.widget({

  name: 'bubbles',

  type: 'output',

  initialize: function(el, width, height) {

    var bubble = d3.layout.pack()
        .sort(null)
        .padding(1.5);
    
    var svg = d3.select(el).append("svg")
        .attr("class", "bubble");
        
    return {
      svg: svg,
      bubble: bubble
    }

  },

  renderValue: function(el, x, instance) {

    // Store the current value so we can easily call renderValue
    // from the resize method below, which doesn't give us an x
    // value
    instance.lastValue = x;

    // Retrieve our svg and bubble objects that were created in
    // the initialize method above
    var svg = instance.svg;
    var bubble = instance.bubble;
    
    // Resize our svg element and bubble layout according to the
    // size of the actual DOM element
    var width = el.offsetWidth;
    var height = el.offsetHeight;
    svg.attr("width", width).attr("height", height);
    bubble.size([width, height]);

    var df = HTMLWidgets.dataframeToD3(x);

    var node = svg.selectAll(".node")
        .data(bubble.nodes({children: df, color: "transparent"}))
      .enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
  
    node.append("title")
        .text(function(d) { return d.tooltip; });
  
    node.append("circle")
        .attr("r", function(d) { return d.r; })
        .style("fill", function(d) { return d.color; });
  
    node.append("text")
        .attr("dy", ".3em")
        .style("text-anchor", "middle")
        .text(function(d) { return d.label; });
  },

  resize: function(el, width, height, instance) {
    // Re-render the previous value, if any
    if (instance.lastValue) {
      this.renderValue(el, instance.lastValue, instance);
    }
  }

});
