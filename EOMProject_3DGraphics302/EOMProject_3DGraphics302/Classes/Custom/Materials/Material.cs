using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EOMProject_3DGraphics302.Classes.Custom.Materials
{
    public abstract class Material
    {
        public virtual void SetEffectParameters(Effect effect) { }
        public virtual void Update() { }
    }
}
