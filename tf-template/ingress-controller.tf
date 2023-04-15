#traefik
# Traefik for the load balancer

#resource "kubernetes_namespace" "traefik" {
    
#    depends_on = [
#        time_sleep.wait_for_kubernetes
#    ]

#    metadata {
#        name = "traefik"
#    }
#}

#resource "helm_release" "traefik" {
 #   depends_on = [
 #       kubernetes_namespace.traefik
 #   ]

 #   name = "traefik"
 #   namespace = "traefik"

 #   repository = "https://helm.traefik.io/traefik"
 #   chart = "traefik"
    # version = "v20.5.0"

    # Set Traefik as the Default Ingress Controller
 #   set {
 #       name  = "ingressClass.enabled"
 #       value = "true"
 #   }
 #   set {
 #       name  = "ingressClass.isDefaultClass"
 #       value = "true"
 #   }
    
    # Default Redirect
 #   set {
 #       name  = "ports.web.redirectTo"
 #       value = "websecure"
    #}

    # Enable TLS on Websecure
   # set {
   #     name  = "ports.websecure.tls.enabled"
  #      value = "true"
 #   }

    # add the latest helm version
   

#}

resource "kubernetes_namespace" "nginx-namespace" {

  depends_on = [time_sleep.wait_for_kubernetes]
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on = [kubernetes_namespace.nginx-namespace, time_sleep.wait_for_kubernetes]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.5.2"

  namespace        = kubernetes_namespace.nginx-namespace.id
  create_namespace = true

  values = [
    file("values.yaml")
  ]

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

 set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  # You can provide a map of value using yamlencode. Don't forget to escape the last element after point in the name
  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  } 
  
}
