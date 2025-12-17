#!/bin/bash

# Configuration
REGION="us-central1" # Ensure this region has GPU quota (e.g. us-central1, us-east4)
JOB_NAME="stereo-crafter-job"
IMAGE_URI="us-central1-docker.pkg.dev/$PROJECT_ID/stereo-crafter"
BUCKET_NAME="stereocrafter-bucket" # REPLACE THIS

# Deploy Cloud Run Job
gcloud run jobs deploy $JOB_NAME \
  --image $IMAGE_URI \
  --region $REGION \
  --task-timeout 60m \
  --device-ids=0 \
  --gpu-type=nvidia-l4 \
  --gpu=1 \
  --add-volume=name=gcs-volume,type=cloud-storage,bucket=$BUCKET_NAME \
  --add-volume-mount=volume=gcs-volume,mount-path=/mnt/gcs \
  --args="--pre_trained_path","/app/weights/stable-video-diffusion-img2vid-xt-1-1" \
  --args="--unet_path","/app/weights/StereoCrafter" \
  --args="--input_video_path","/mnt/gcs/input_video.mp4" \
  --args="--save_dir","/mnt/gcs/results"
