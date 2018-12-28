
# basic network configuration
base_folder = '%DVT_ROOT%/'
caffevis_deploy_prototxt = base_folder + 'models/my_model/deploy.prototxt'
caffevis_network_weights = base_folder + 'models/my_model/solver_iter_40000.caffemodel'
#caffevis_data_mean       = base_folder + 'models/caffenet-yos/ilsvrc_2012_mean.npy'

# input images
static_files_dir = base_folder + './input_images/Ctrl_D_2'

# UI customization
caffevis_label_layers    = ['My_score', 'prob']
caffevis_labels          = base_folder + 'models/my_model/labelName.txt'
caffevis_prob_layer      = 'prob'

def caffevis_layer_pretty_name_fn(name):
    return name.replace('pool','p').replace('norm','n')

# offline scripts configuration
# caffevis_outputs_dir = base_folder + './models/caffenet-yos/unit_jpg_vis'
caffevis_outputs_dir = base_folder + 'models/my_model/outputs_CtrlD'
layers_to_output_in_offline_scripts = ['layer_512_3_sum']
