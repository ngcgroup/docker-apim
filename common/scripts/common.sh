POSITIONAL_ARGS=()
function parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -p|--profile)
          profile="--profile $2"
          shift # past argument
          shift # past value
          ;;  
      -d|--dry-run)
          dry_run=" --dry-run=client -o yaml"
          shift # past argument
          #shift # past value
          ;;   
      -u|--push)
          docker_push="true"
          shift # past argument
          #shift # past value
        ;; 
      -l|--login)
          docker_login="true"
          shift # past argument
          #shift # past value
          ;;
      -c|--create-repository)
        docker_cr="true"
        shift # past argument
        #shift # past value
        ;;
      --force)
        force="true"
        shift # past argument
        #shift # past value
        ;;        
      --cleanup)
        cleanup="true"
        shift # past argument
        #shift # past value
        ;;                
       -s|--skip-download)
        skip_download="true"
        shift # past argument
        #shift # past value
        ;; 
      -t|--tenant)
        tenant=$2
        shift # past argument
        shift # past value
        ;;                
      -*|--*)
        echo "Unknown option $1"
        exit 1
        ;;
      *)
        POSITIONAL_ARGS+=("$1") # save positional arg
        shift # past argument
        ;;
    esac
  done
}
## set AWS_PROFILE to whatever you want or use --profile, no default
#if [ "$profile" == "" ]; then 
#	profile="arch"
#fi



function source_env_from_aws() {
  TEMPIFS=$IFS; 
  IFS=$'\n'; 
  rm -rf env-file
  echo "## title ##" >> env-file
  for line in $(aws ssm get-parameters-by-path ${profile} --path $app --query "Parameters[*].{Name:Name,Value:Value}" | jq -r '.[] |[.Name, .Value] | @tsv' | sed "s/${app2}//g" | sed "s/^\///g" |awk -F '\t' '{print $1"="$2}'); do
    if [[ "$line" =~ ^([a-zA-Z0-9_]*)=(.*)$ ]]; then 
      #export ${BASH_REMATCH[1]}=${BASH_REMATCH[2]}; 
      echo ${BASH_REMATCH[1]}=${BASH_REMATCH[2]} >> env-file
      #envargs="${envargs} --env=\"${BASH_REMATCH[1]}=${BASH_REMATCH[2]}\""
    fi; 
  done; 
  ##local bash overrides ## if you are lazy about prod changes
  env | grep "^ENV" | sed 's/^ENV_//g'>> env-file
  IFS=$TEMPIFS;  
}

function docker_login() {
    if [ "$docker_login" == "true" ]; then
      echo "logging in" 
      aws ecr get-login-password $profile | docker login --username AWS --password-stdin $1
    fi
}

function docker_push() {
    if [ "$docker_push" == "true" ]; then
      docker push $1
    fi
}

function docker_create_repository() {
    if [ "$docker_cr" == "true" ]; then
      aws ecr create-repository $profile\
>     --repository-name $1
    fi
}

parse_args $@
