var neuralNetwork = (divName, data, colorsNodes, colorsLinks, margin, height, width, strength, strokeWidth, rSize, font, tools) => {
  let nbrLiens = data.nodes.map(function(d) {
    tmpNode = {
      "label": d.label
    };
    nbrL = 0;
    data.links.forEach(function(e) {
      if (e.source == d.label || e.target == d.label) {
        nbrL++;
      }
    });
    tmpNode.nbrL = nbrL;
    return tmpNode;
  });

  // On définit le SVG et sa taille
  let svg = d3.select(divName)
    .append("svg")
    .attr("viewBox", '0 0 ' + (width + 2 * margin) + ' ' + (height + 2 * margin))
    .append("g")
    .attr("transform",
      "translate(" + margin + "," + margin + ")");
	  
  let coeff = (width + 2 * margin) / d3.select(divName).node().getBoundingClientRect().width;

  // On définit les forces qui vont agir sur les noeuds
  let simulation = d3.forceSimulation()
    // Mets les liens liés à bonne distance
    .force("link", d3.forceLink().id(function(d) {
      return d.label;
    }))
    // Applique une force sur tous les noeuds
    // Ici, la valeur négative de strength permet au noeuds de se repousser
    // entre eux
    // de sorte qu'ils remplissent l'espace, plus c'est négatif plus les
    // bulles se repoussent
    .force("charge", d3.forceManyBody().strength(strength))
    // Translate les noeuds au centre
    .force("center", d3.forceCenter(width / 2, height / 2));

  // On ajoute les liens entre les noeuds
  let link = svg.append("g")
    .attr("class", "links")
    .selectAll("line")
    .data(data.links)
    .enter().append("line")
    .attr("stroke-width", function(d) {
      return Math.sqrt(d.val) * strokeWidth;
    })
	.attr("stroke", function(d) {
      return colorsLinks[d.group];
    });

  // On ajoute les cercles des noeuds
  let node = svg.append("g")
    .attr("class", "nodes")
    .selectAll("circle")
    .data(data.nodes)
    .enter()
    .append("circle")
    .attr("r", function(d) {
      return Math.pow(3 + d.size, rSize);
    })
    .attr("fill", function(d) {
      return colorsNodes[d.group];
    })
    // On appelle la fonction qui permet de déplacer les noeuds en cliquant
    // dessus
    .call(drag(simulation))
    // On gère le tooltip
    .on("mouseover", function(d, i) {
      if (tools) {
        //if (nbrLiens[i].nbrL < 100) {
          onmouseover(d, tooltip);
        //}
      }
    })
    .on("mouseout", function(d, i) {
      if (tools) {
        //if (nbrLiens[i].nbrL < 100) {
		  onmouseout(d, tooltip);
        //}
      }
    });

  // On ajoute les textes à côté de chaque cercle
  let labels = svg.append("g")
    .attr("class", "texts")
    .selectAll("text")
    .data(data.nodes)
    .enter()
    .append("text")
    .text(function(d, i) {
      //if (nbrLiens[i].nbrL >= 100) return d.label;
    })
    .attr('x', 0)
    .attr('y', function(d) {
      return -3 - Math.pow(3 + d.size, rSize);
    })
    .attr('text-anchor', 'middle')
    .attr("font-family", font[1])
    .attr('font-size', 14);

  // On applique la simulation aux noeuds
  simulation
    .nodes(data.nodes)
    .on("tick", () => {
      link
        .attr("x1", function(d) {
          return d.source.x;
        })
        .attr("y1", function(d) {
          return d.source.y;
        })
        .attr("x2", function(d) {
          return d.target.x;
        })
        .attr("y2", function(d) {
          return d.target.y;
        });

      node
        .attr("cx", function(d) {
          return d.x = Math.max(Math.pow(3 + d.size, rSize),
            Math.min(width - Math.pow(3 + d.size, rSize), d.x));
        })
        .attr("cy", function(d) {
          return d.y = Math.max(Math.pow(3 + d.size, rSize),
            Math.min(height - Math.pow(3 + d.size, rSize), d.y));
        });

      labels
        .attr("transform", function(d) {
          return "translate(" + Math.max(Math.pow(3 + d.size, rSize),
              Math.min(width - Math.pow(3 + d.size, rSize), d.x)) + "," +
            Math.max(Math.pow(3 + d.size, rSize),
              Math.min(height - Math.pow(3 + d.size, rSize), d.y)) + ")";
        });
    });

  // On fournit à la simulation les liens
  simulation.force("link")
    .links(data.links);

  // Gère le déplacement des noeuds lorsqu'on clique dessus
  function drag(simulation) {
    function dragstarted(d) {
      if (!d3.event.active) simulation.alphaTarget(0.3).restart();
      d.fx = d.x;
      d.fy = d.y;
    }

    function dragged(d) {
      d.fx = d3.event.x;
      d.fy = d3.event.y;
    }

    function dragended(d) {
      if (!d3.event.active) simulation.alphaTarget(0);
      d.fx = null;
      d.fy = null;
    }

    return d3.drag()
      .on("start", dragstarted)
      .on("drag", dragged)
      .on("end", dragended);
  }

  // ** TOOLTIP **//
  let tooltip;
  if (tools) {
    d3.select(divName).style("position", "relative");	 
    tooltip = d3.select(divName)
      .append("div")
	  .attr("class", "tooltip-neural-network")
	  .attr("style", "position: absolute; z-index: 19; width :" + (width / 2 - margin) / coeff + "px;"
	      + "font-family: " + font[1] + "; font-weight: 500; font-size:" + 12 / coeff + "px; color: #F4F4F4; padding: 10px;")
	  .style("opacity", 0);
	
    function onmouseover(d, tooltip) {
      tooltip.style("z-index", 19)
      tooltip.transition()
	    .duration(500)
	    .style("opacity", 0.95)
	    .style("background", "#333232");
	  let leftPos = (d.x - width / 2 < 0) ? 1.5 * margin + width / 2 : 1.5 * margin;
      tooltip.html(d.label)
	    .style("top", (1.5 * margin / coeff) + "px")
	    .style("left", leftPos / coeff + "px");
    }

    function onmouseout(d, tooltip) {
      tooltip.transition()
	    .duration(500)
	    .style("opacity", 0)
	    .style("z-index", -1);
    }
  }
  // ** TOOLTIP **//
}
