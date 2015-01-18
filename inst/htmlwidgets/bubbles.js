HTMLWidgets.widget({

  name: 'bubbles',

  type: 'output',

  initialize: function(el, width, height) {

    var bubble = d3.layout.pack()
        .sort(null)
        .size([width, height])
        .padding(1.5);
    
    var svg = d3.select(el).append("svg")
        .attr("width", width)
        .attr("height", height)
        .attr("class", "bubble");
        
    return {
      svg: svg,
      width: width,
      height: height,
      bubble: bubble
    }

  },

  renderValue: function(el, x, instance) {

    var svg = instance.svg;
    var bubble = instance.bubble;

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

  }

});
