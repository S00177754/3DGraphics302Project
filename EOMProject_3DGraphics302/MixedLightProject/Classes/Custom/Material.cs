using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MixedLightProject.Classes.Custom
{
    public abstract class Material
    {
        public virtual void SetEffectParameters(Effect effect) { }
        public virtual void Update() { }
    }
}
