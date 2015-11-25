HTMLWidgets.widget({

    name: 'd3bubbles',

    type: 'output',

    renderOnNullValue: true,

    initialize: function(el, width, height) {

        var bubble = d3.layout.pack()
            .sort(null)
            // .padding(1);
            ;

        var svg = d3.select(el).append("svg")
            .attr("class", "bubble");

        return {
            svg: svg,
            bubble: bubble
        }

    },

    renderValue: function(el, x, instance) {


        var opts = x.settings;

console.log("X1\n",x)
console.log("settings\n",x.settings)
console.log("opts\n",opts)
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
        bubble.padding(opts.padding);

        var df = HTMLWidgets.dataframeToD3(x.d);

        var node = svg.selectAll(".node")
            .data(bubble.nodes({children: df, color: "transparent"}),
          (!x.d || !x.d.key) ? null : function(d) { return d.key; });

        // Create new nodes, and set their starting state so they look
        // good when they transition to their new state
        var newNode = node.enter()
            .append("g").attr("class", "node")
            .style("opacity", 0)
            .attr("transform", function(d) {
                return "translate(" + width / 2 + "," + height / 2 + ")";
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
            .text(function(d) {
                return d.tooltip;
            });

        node.select("circle").transition()
            .attr("r", function(d) {
                return d.r;
            })
            .style("fill", function(d) {
                return d.color;
            });

        node.select("text")
            .text(function(d) {
                return d.label;
            })
            .style("font-size", function(d) { 
                // http://bl.ocks.org/mbostock/1846692
                return Math.min(2 * d.r, (2 * d.r - 8) / this.getComputedTextLength() * 18) + "px"; 
            })
            .style("fill", function(d) {
                return d.textColor;
            })
            .call(d3TextWrap,opts.textSplitWidth || 80,0,0)
            ;




/**
 * Function allowing to 'wrap' the text from an SVG <text> element with <tspan>.
 * Based on https://github.com/mbostock/d3/issues/1642
 * @exemple svg.append("g")
 *      .attr("class", "x axis")
 *      .attr("transform", "translate(0," + height + ")")
 *      .call(xAxis)
 *      .selectAll(".tick text")
 *          .call(d3TextWrap, x.rangeBand());
 *
 * @param text d3 selection for one or more <text> object
 * @param width number - global width in which the text will be word-wrapped.
 * @param paddingRightLeft integer - Padding right and left between the wrapped text and the 'invisible bax' of 'width' width
 * @param paddingTopBottom integer - Padding top and bottom between the wrapped text and the 'invisible bax' of 'width' width
 * @returns Array[number] - Number of lines created by the function, stored in a Array in case multiple <text> element are passed to the function
 */
function d3TextWrap(text, width, paddingRightLeft, paddingTopBottom) {
    paddingRightLeft = paddingRightLeft || 0; //Default padding (5px)
    width = width - (paddingRightLeft * 2); //Take the padding into account

    paddingTopBottom = (paddingTopBottom || 0) - 0; //Default padding (5px), remove 2 pixels because of the borders

    var textAlign = text.attr('text-anchor') || 'left';
    var arrLineCreatedCount = [];
    text.each(function() {
        var text = d3.select(this),
            words = text.text().split(/[ \f\n\r\t\v]+/).reverse(), //Don't cut non-breaking space (\xA0), as well as the Unicode characters \u00A0 \u2028 \u2029)
            word,
            line = [],
            lineNumber = 0,
            lineHeight = 1, //Ems
            x = text.attr("x"),
            y = text.attr("y"),
            dy = parseFloat(text.attr("dy")),
            createdLineCount = 1; //Total line created count

        //Clean the data in case <text> does not define those values
        if (isNaN(dy)) dy = 1; //Default padding (1em)
        var dx;
        if (textAlign === 'middle') { //Offset the text according to the anchor
            dx = width / 2;
        }
        else { //'left' and 'right' //FIXME text-anchor 'right' does not have any effect on tspans, only 'left' and 'middle' -> bug ?
            dx = 0;
        }
        x = ((null === x)?paddingRightLeft:x) + dx; //Default padding (5px)
        y = (null === y)?paddingTopBottom:y; //Default padding (5px)

        var tspan = text.text(null).append("tspan").attr("x", x).attr("y", y).attr("dy", dy + "em");
        //noinspection JSHint
        while (word = words.pop()) {
            line.push(word);
            tspan.text(line.join(" "));
            if (tspan.node().getComputedTextLength() > width && line.length > 1) {
                line.pop();
                tspan.text(line.join(" "));
                line = [word];
                tspan = text.append("tspan").attr("x", x).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
                ++createdLineCount;
            }
        }

        arrLineCreatedCount.push(createdLineCount); //Store the line count in the array
    });
    return arrLineCreatedCount;
}





    },

    resize: function(el, width, height, instance) {
        // Re-render the previous value, if any
        if (instance.lastValue) {
            this.renderValue(el, instance.lastValue, instance);
        }
    }

});
