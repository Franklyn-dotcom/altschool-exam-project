resource "kubernetes_ingress_v1" "micro-ingress" {
  metadata {
    name      = "sock-shop"
    namespace = "sock-shop"
    labels = {
      name = "front-end"
    }
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
    }
  }

  spec {
    rule {
      host = "sock-shop.alwaysforever.me"
      http {
        path {
          backend {
            service{
              name = "front-end"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}



resource "kubernetes_ingress_v1" "portfolio-ingress" {
  metadata {
    name      = "web-app"
    namespace = "web-app"
    labels = {
      name = "web-app"
    }
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
    }
  }

  spec {
    rule {
      host = "web-app.alwaysforever.me"
      http {
        path {
          backend {
            service{
              name = "postgres"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
