export MODEL_NAME="models/Diffusion_Transformer/Wan2.1-T2V-14B"
export TRAIN_PROMPT_PATH="MovieGenVideoBench_train.txt"
# Performing validation simultaneously with training will increase time and GPU memory usage.
export VALIDATION_PROMPT_PATH="MovieGenVideoBench_val.txt"

accelerate launch --num_processes=1 --mixed_precision="bf16" scripts/wan2.1/train_reward_lora.py \
  --config_path="config/wan2.1/wan_civitai.yaml" \
  --pretrained_model_name_or_path=$MODEL_NAME \
  --rank=32 \
  --network_alpha=16 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=1 \
  --max_train_steps=10000 \
  --checkpointing_steps=100 \
  --learning_rate=1e-05 \
  --seed=42 \
  --output_dir="output_dir" \
  --gradient_checkpointing \
  --vae_gradient_checkpointing \
  --mixed_precision="bf16" \
  --adam_weight_decay=3e-2 \
  --adam_epsilon=1e-10 \
  --max_grad_norm=0.3 \
  --prompt_path=$TRAIN_PROMPT_PATH \
  --train_sample_height=480 \
  --train_sample_width=832 \
  --num_inference_steps=30 \
  --video_length=81 \
  --num_decoded_latents=1 \
  --reward_fn="HPSReward" \
  --reward_fn_kwargs='{"version": "v2.1"}' \
  --backprop_strategy "tail" \
  --backprop_num_steps 5 \
  --backprop