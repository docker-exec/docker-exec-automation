workspace_dir=".workspace"
config_file=".dbot"

dir_types=(all base dexec image web dbot)
global_ops=(clean upweb)
dbot_ops=(upreadme)
danger_ops=(rewrite fpush fmodule clean)

ops=($(grep -Ee "^function op_" "${0}" ${script_path}/script/ops-*.sh \
            | sed -Ee 's/.+ op_(.+)\(\).+/\1/' \
            | sort))
for global_op in "${global_ops[@]}"; do
    ops=("${ops[@]/$global_op}")
done

git_ops=($(grep -Ee "^function op_" "${0}" "${script_path}/script/ops-git.sh" \
            | sed -Ee 's/.+ op_(.+)\(\).+/\1/' \
            | sort))

text_ops=($(grep -Ee "^function op_" "${0}" "${script_path}/script/ops-text.sh" \
            | sed -Ee 's/.+ op_(.+)\(\).+/\1/' \
            | sort))
