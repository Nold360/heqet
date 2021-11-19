# Very simple container for argo-cd plugin
FROM alpine/helm:latest

COPY cli/hqt /usr/local/bin/ 
COPY conf/plugin.yaml /home/argocd/cmp-server/config/plugin.yaml

# Clear entrypoint & cmd
ENTRYPOINT
CMD
