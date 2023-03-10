<!-- from https://pygments.org/demo/#try -->
<div class="highlight" style="background: #f8f8f8">
<pre style="line-height: 125%"><span style="color: #408080; font-style: italic"># Physics Derivation Graph</span>
<span style="color: #408080; font-style: italic"># Ben Payne, 2021</span>
<span style="color: #408080; font-style: italic"># https://creativecommons.org/licenses/by/4.0/</span>
<span style="color: #408080; font-style: italic"># Attribution 4.0 International (CC BY 4.0)</span>

<span style="color: #408080; font-style: italic"># https://docs.docker.com/engine/reference/builder/#from</span>
<span style="color: #408080; font-style: italic"># https://github.com/phusion/baseimage-docker</span>
<span style="color: #008000; font-weight: bold">FROM</span><span style="color: #BA2121"> phusion/baseimage:0.11</span>

<span style="color: #408080; font-style: italic"># PYTHONDONTWRITEBYTECODE: Prevents Python from writing pyc files to disk (equivalent to python -B option)</span>
<span style="color: #008000; font-weight: bold">ENV</span> PYTHONDONTWRITEBYTECODE <span style="color: #666666">1</span>

<span style="color: #408080; font-style: italic"># https://docs.docker.com/engine/reference/builder/#run</span>
<span style="color: #008000; font-weight: bold">RUN</span> apt-get update <span style="color: #666666">&amp;&amp;</span> <span style="color: #BB6622; font-weight: bold">\</span>
    apt-get install -y <span style="color: #BB6622; font-weight: bold">\</span>
               python3 <span style="color: #BB6622; font-weight: bold">\</span>
               python3-pip <span style="color: #BB6622; font-weight: bold">\</span>
               python3-dev <span style="color: #BB6622; font-weight: bold">\</span>
    <span style="color: #666666">&amp;&amp;</span> rm -rf /var/lib/apt/lists/*
</pre></div>