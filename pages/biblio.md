---
title: Biliografía
layout: page
permalink: /biblio.html
---


## Bibliografía

(Recuperada de [colección Zotero](https://www.zotero.org/groups/6629195/fanzines_argentinos/library))

<div id="zotero-bib">Cargando bibliografía…</div>

<script>
const groupID = "6629195";
const limit = 100;

fetch(`https://api.zotero.org/groups/${groupID}/items/top?format=json&limit=${limit}`)
  .then(response => response.json())
  .then(data => {
    const lastName = c => c?.lastName || c?.name || "";
    const items = data
      .filter(item => item.data.itemType !== "attachment" && item.data.itemType !== "note")
      .sort((a, b) => {
        const aKey = lastName(a.data.creators?.[0]) || a.data.title || "";
        const bKey = lastName(b.data.creators?.[0]) || b.data.title || "";
        return aKey.localeCompare(bKey, "es", { sensitivity: "base" });
      });
    const container = document.getElementById("zotero-bib");
    container.innerHTML = "";
    items.forEach(item => {
      const { title, creators, date, publicationTitle, url } = item.data;
      const authors = (creators || [])
        .map(c => c.name || [c.lastName, c.firstName].filter(Boolean).join(", "))
        .join("; ");
      const citation = [authors, title, publicationTitle, date].filter(Boolean).join(". ") + ".";
      const div = document.createElement("div");
      div.style.marginBottom = "1em";
      div.style.paddingLeft = "2em";
      div.style.textIndent = "-2em";
      div.textContent = citation + " ";
      if (url) {
        const a = document.createElement("a");
        a.href = url;
        a.target = "_blank";
        a.rel = "noopener";
        a.textContent = url;
        div.appendChild(a);
      }
      container.appendChild(div);
    });
  })
  .catch(error => {
    console.error("Error:", error);
    document.getElementById("zotero-bib").innerHTML = 'No se pudo cargar la bibliografía. Consultarla en <a href="https://www.zotero.org/groups/' + groupID + '/fanzines_argentinos/library">Zotero</a>.';
  });
</script>

