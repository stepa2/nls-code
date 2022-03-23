-- NLS/ConRed shared code

print("NLCR > Initialization started "..(CLIENT and "clientside" or "serverside"))

include("nlcr/_include.lua")

print("NLCR > Initialization finished")

hook.Run("NLCR.AfterInit")