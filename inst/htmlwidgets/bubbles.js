HTMLWidgets.widget({

  name: 'bubbles',

  type: 'output',
  
  renderOnNullValue: false,

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

    // Set up our main selection
    var node = svg.selectAll(".node")
        .data(bubble.nodes({children: df, color: "transparent"}),
          (!x || !x.key) ? null : function(d) { return d.key; }
        );

    // Create new nodes, and set their starting state so they look
    // good when they transition to their new state
    var newNode = node.enter()
        .append("g").attr("class", "node")
        .style("opacity", 0)
        .attr("transform", function(d) {
          return "translate(" + width/2 + "," + height/2 + ")";
        });

    newNode.append("title");
    newNode.append("circle")
        .style("fill", "#FFFFFF");
    newNode.append("text")
        .attr("dy", ".3em")
        .style("text-anchor", "middle");

    // Remove old nodes
    node.exit().transition()
        .remove()
        .style("opacity", 0);

    // Update all new and remaining nodes

    node.transition()
        .style("opacity", 1)
        .attr("transform", function(d) {
          return "translate(" + d.x + "," + d.y + ")";
        });

    node.select("title")
        .text(function(d) { return d.tooltip; });

    node.select("circle").transition()
        .attr("r", function(d) { return d.r; })
        .style("fill", function(d) { return d.color; });

    node.select("text")
        .text(function(d) { return d.label; })
        .style("fill", function(d) { return d.textColor; });
  },

  resize: function(el, width, height, instance) {
    // Re-render the previous value, if any
    if (instance.lastValue) {
      this.renderValue(el, instance.lastValue, instance);
    }
  }

});
