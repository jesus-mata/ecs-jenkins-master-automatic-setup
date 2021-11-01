FROM jenkins/jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
#ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

COPY plugins-minimal.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY initialConfig.groovy /usr/share/jenkins/ref/init.groovy.d/initialConfigs.groovy
COPY casc.yaml /usr/share/jenkins/ref/jenkins.yaml