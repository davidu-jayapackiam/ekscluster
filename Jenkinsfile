pipeline {

   parameters {
    choice(name: 'action', choices: 'create\ndestroy', description: 'Create/update or destroy the eks cluster.')
	string(name: 'cluster', defaultValue : 'demo', description: "EKS cluster name;eg demo creates cluster named eks-demo.")
  }
  
  agent any
  
  stages {
     stage('checkout') {
        steps {
            git 'https://github.com/chavaliInfy/ekscluster.git'
        }
    }
	stage('Setup') {
		steps {
			script {
				currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + " eks-" + params.cluster
				plan = params.cluster + '.plan'
			}
		}
	}
    stage('Set Terraform path') {
        steps {
            script {
                def tfHome = tool name: 'terraform'
                env.PATH = "${tfHome}:${env.PATH}"
            }
            sh 'terraform -version'
        }
    }
    stage('TF Plan') {
      when {
        expression { params.action == 'create' }
		}	
		steps {
			script {
			dir('.') {
			 //	withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
					// withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'genawsid', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
		                          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'cred-dev-ecr-jenkins-eks-new', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
		
						//       withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'cred-dev-ecr-jenkins-eks-new', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) { 
	
					sh """
					#terraform init -reconfigure
					 terraform init
				 terraform workspace new ${params.cluster} || true
               # terraform workspace new demo-aspire10
					terraform workspace select ${params.cluster}
                #terraform workspace select demo-aspire3
					terraform plan \
					-var cluster-name=${params.cluster} \
						-out ${plan} 
            #    terraform plan -var cluster-name=${params.cluster}  -lock=false
					echo ${params.cluster}
				"""
				}
			}
        }
      }
    }
    stage('TF Apply') {
      when {
        expression { params.action == 'create' }
		}	
		steps {
			script {
			dir('.') {
				// withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'cred-dev-ecr-jenkins-eks-new', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'genawsid', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
					if (fileExists('$HOME/.kube')) {
					echo '.kube Directory Exists'
				} else {
				sh 'mkdir -p $HOME/.kube'
				}
				sh """
					 terraform apply -input=false -auto-approve ${plan}
					 terraform output kubeconfig > $HOME/.kube/config
				"""
				sh 'sudo chown $(id -u):$(id -g) $HOME/.kube/config'
				sleep 30
				//sh '$(which kubectl) kubectl get nodes'
				}
			}
        }
      }
    }
/*
    stage('TF Destroy') {
      when {
        expression { params.action == 'destroy' }
      }
      steps {
        script {
			dir('.') {
				# withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'cred-dev-ecr-jenkins-eks-new', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'genawsid', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
				sh """
				terraform workspace select ${params.cluster}
            # terraform workspace select demo-aspire1
				terraform destroy -auto-approve
				"""
				}
			}
        }
      }  
    } */
  }
}
