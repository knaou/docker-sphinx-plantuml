# docker-shpinx-plantuml

Docker image of shpinx with plantyml and Japanese font

# Quick start

Call sphinx-quickstart and create initialized reST files.

    docker run -v /path/to/doc:/work knaou/sphinx-plantuml sphinx-quickstart

And, edit files you want.

# Use PlantUML

If, you want to use PlantUML, write follow settings into *conf.py*.

    # Added for plantuml
    extensions += ['sphinxcontrib.plantuml']
    plantuml = 'java -jar /opt/plantuml/plantuml.jar'

Then, you can render uml directive like this.

    .. uml::

        Hoge --> Piyo

