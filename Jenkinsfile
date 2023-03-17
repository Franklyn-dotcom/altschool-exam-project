// pipeline {
//     agent any 

//     // environment {
//     //     KUBECONFIG = credentials('civo-my-k8s-cluster-kubeconfig')
//     // }
//     // create the stages for the application
//     stages {
//         stage ("Clone") {
//             steps {
//                 git "https://github.com/microservices-demo/microservices-demo.git"
                
//             }
//         }
        

//         stage ("Build and Run"){
//             steps {
//                 // sh "kubectl create namespace kubernetes"
//                 sh 'kubectl apply -f complete-demo.yaml'
//                 sh "cd microservices-demo/deploy/kubernetes/manifests-monitoring"
//                 sh "kubectl create -f 00-monitoring-ns.yaml"
//                 // sh "kubectl apply $(ls *-prometheus-*.yaml | awk ' { print " -f " $1 } ')"
//                 sh "kubectl create -f ./microservices-demo/deploy/kubernetes/manifests-alerting"
//             }
//         }

//         stage ("Deploy") {
//             steps {
//                  withKubeConfig([credentialsId: 'kubernetes', serverUrl: "https://74.220.29.252:6443"]) {
//                  sh 'kubectl apply -f ./microservices-demo/deploy/kubernetes/complete-demo.yaml'
//             }
//         }
//      }

//     }
// }


pipeline {
    agent any
    environment {
        CIVO_TOKEN = credentials('CIVO_TOKEN')
        CIVO_REGION = "FRA1"
    }
    stages {
        stage("Create k8s and nginx-controller") {
            steps {
                script {
                    dir('tf-template') {
                       sh "civo eks kubeconfig --region=FRA1 --cluster=kubefig > kubeconfig.yaml
kubectl config use-context civo"
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

       
        stage("Deploy portfolio-app to K8s") {
            steps {
                script {
                    dir('portfolio') {
                        sh "kubectl apply -f web-app.yaml"
                        sh "kubectl apply -f web-service.yaml"
                        sh "kubectl apply -f postgres.yaml"
                        sh "kubectl apply -f nginx-config.yaml"
                        sh "kubectl apply -f postgres-config.yaml"
                    }
                }
            }
        }

        

          
        }
    }
}
