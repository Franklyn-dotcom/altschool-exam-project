resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "sock-shop"
  }
}

resource "kubernetes_ingress_v1" "portfolio-ingress" {
  metadata {
    name      = "web-app-portfoilio"
    labels = {
      name = "web-app-portfolio"
    }
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
    }
  }

  spec {
    rule {
      host = "web-app-portfolio.mbanugo.bulgogi174.messwithdns.com"
      http {
        path {
          backend {
            service{
              name = "web-app-portfolio"
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

resource "kubernetes_ingress_v1" "shop-ingress" {
  metadata {
    name      = "sock-shop"
    namespace = "sock-shop"
    labels = {
      name = "web-app"
    }
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
    }
  }

  spec {
    rule {
      host = "sock-shop.mbanugo.bulgogi174.messwithdns.com"
      http {
        path {
          backend {
            service{
              name = "web-app"
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
