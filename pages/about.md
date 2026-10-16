---
title: Acerca de
layout: about
permalink: /about.html
# include CollectionBuilder info at bottom
credits: true
# Look in _includes/feature for options to easily add features to the page
---

{% include feature/nav-menu.html sections="Sobre el proyecto;Marcos teóricos;Bibliografía;" %}

## Sobre el proyecto

Fanzines argentinos se propone analizar el fenómeno de las publicaciones independientes y
alternativas (fanzines o zines) en Argentina entre 1990 y 2001 que reflejan la emergencia de
diversas contraculturas y movimientos sociales y políticos, entre los que se destacan el punk, el
anarquismo, la ecología, el vegetarianismo, el feminismo, así como las escenas musicales del punk
rock y el hardcore.

El proyecto trabaja sobre un conjunto documental heterogéneo que es parte del archivo privado
de Santiago Cichero e incluye una amplia diversidad de soportes físicos y técnicas que varían
desde el formato puramente artesanal hasta producciones de acabado más estructurado o profesional. El marco temporal en el que se elaboran estos zines estuvo profundamente atravesado por las políticas de privatización y neoliberalismo en Argentina, así como por procesos de exclusión social y crisis económica que finalizaron con el quiebre de la economía argentina en 2001.

El plan de trabajo del proyecto abarca el desarrollo de infraestructura digital, la catalogación
normalizada y la visualización de datos:

1. **Flujo de trabajo e infraestructura digital**: Digitalización artesanal, catalogación, publicación y preservación de los zines mediante Internet Archive y Collection Builder.

2. **Organización del conocimiento y vocabulario controlado**: Desarrollo e implementación de un vocabulario controlado especializado en fanzines, disponible a través del [Portal de terminologías de la Facultad de Filosofía y Letras de la Universidad de Buenos Aires](https://terminologias.filo.uba.ar/apps/fanzinar/index.php).

3. **Visualizaciones de datos**: Secciones dedicadas a la visualización analítica del corpus para estudiar patrones de circulación, temas y conexiones dentro del archivo.

## Marcos Teóricos: El zine como «espacio fronterizo» y dispositivo híbrido {#marcos-teóricos}

**Título**

Uno de los aportes centrales del proyecto es la conceptualización teórica del fanzine como un
objeto liminar y un espacio de frontera:

* Desdibujamiento de categorías: El zine problematiza y desdibuja las fronteras tradicionales entre géneros discursivos y categorías de objeto literario convencionales.

* Distanciamiento del campo editorial tradicional: El zine no responde ni a las convenciones formales de las revistas comerciales estructuradas ni a las lógicas de validación y legitimación propias del campo editorial hegemónico.

* Materialidad signante: El soporte material —caracterizado por el uso de fotocopias, grapas o abrochados, técnicas de collage, y tipografías manuales o digitales precarias— posiciona al zine en un umbral donde no se define plenamente como revista ni como mero panfleto. En este sentido, la materialidad no es un mero contenedor, sino una parte constitutiva del propio significado y de la posición política de la obra.

* Dispositivo híbrido: Dentro de un mismo ejemplar pueden convivir de manera simultánea expresiones diversas como poesía, crónica, manifiesto político, ilustración e historieta.

* Cuestionamiento a la autoría: Esta lógica fragmentaria e híbrida desafía directamente la
noción moderna de obra unitaria y la figura de autoría individual, única y estable.


## Bibliografía

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

