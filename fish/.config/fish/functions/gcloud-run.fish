function gcloud-run
    gcloud run deploy $argv \
        --image gcr.io/refined-dogfish-353918/$argv \
        --platform managed \
        --region southamerica-east1 \
        --allow-unauthenticated
end
