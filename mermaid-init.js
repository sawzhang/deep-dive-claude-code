document.addEventListener("DOMContentLoaded", function () {
  mermaid.initialize({ startOnLoad: false, theme: "default" });
  // Convert ```mermaid code blocks to mermaid divs
  document.querySelectorAll("pre code.language-mermaid").forEach(function (el) {
    var div = document.createElement("div");
    div.className = "mermaid";
    div.textContent = el.textContent;
    el.parentElement.replaceWith(div);
  });
  mermaid.run();
});
