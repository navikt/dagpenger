{% for howto in site.howtos %}
- [{{ howto.title }}]({{ howto.url | relative_url}})
  {% endfor %}