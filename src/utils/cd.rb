def change_dir(dir)
  if !test ?e, dir
    $> << "No folder named '#{dir}' in this directory\n".red
    !has_git? && $Prompt = $dir 
  else
    CMDS[:cd][0]::(dir)
    has_git? || $Prompt = $dir.magenta
  end
end
