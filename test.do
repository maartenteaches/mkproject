clear all
cd "c:\mijn documenten\projecten\stata\mkproject"
run mkproject_main.mata

mata:
totest = mkproject()
totest.read_profile()
end
