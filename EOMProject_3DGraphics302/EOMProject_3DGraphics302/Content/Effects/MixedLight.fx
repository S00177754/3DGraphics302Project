#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

matrix World;
matrix View;
matrix Projection;

float3 DiffuseColor = float3(1, 1, 1);
float3 AmbientColor = float3(0.15, 0.15, 0.15);

float3 Position = float3(40, 5, 10);
float3 LightColor = float3(1, 1, 1);
float Attenuation = 80;
float FallOff = 2;

texture Texture;
sampler TextureSampler = sampler_state
{
    texture = <Texture>;
};

texture NormalTexture;
sampler NormalSampler = sampler_state
{
    texture = <NormalTexture>;
};

//Phong lighting
float3 CameraPosition;
float3 SpecularColor = float3(1, 1, 1);
float3 SpecularPower = 64;

struct VertexShaderInput
{
	float4 Position : POSITION0;
	float2 UV : TEXCOORD0;
    float3 Normal : NORMAL0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
	float2 UV : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 WorldPosition : TEXCOORD2; //world position of vertex
    float3 ViewDirection : TEXCOORD3;
};

VertexShaderOutput MainVS(in VertexShaderInput input)
{
    VertexShaderOutput output;

    float4 worldPosition = mul(input.Position, World);
    float4 viewPosition = mul(worldPosition, View);

    output.Position = mul(viewPosition, Projection);
    output.WorldPosition = worldPosition;
    output.Normal = mul(input.Normal, World);
    output.ViewDirection = normalize(worldPosition.xyz - CameraPosition);
    output.UV = input.UV;
    
    return output;
}

float4 MainPS(VertexShaderOutput input) : COLOR
{
    float3 color = DiffuseColor;
    color *= tex2D(TextureSampler, input.UV);
    
    float3 lighting = AmbientColor;
    float3 lightDirection = normalize(Position - input.WorldPosition);
    
    float3 normal = tex2D(NormalSampler, input.UV).rgb;
    normal = normal * 2 - 1;
    
    float3 intensity = saturate(dot(lightDirection, normal)) * LightColor;
    
    float3 reflection = reflect(lightDirection, normal);
    lighting += pow(saturate(dot(reflection, input.ViewDirection)), SpecularPower) * SpecularColor;
    
    float dist = distance(Position, input.WorldPosition);
    float att = 1 - pow(clamp(dist / Attenuation, 0, 1), FallOff);
    
    lighting += intensity;
    
    return float4(saturate(lighting * att * color), 1);
}

technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};

technique SpriteDrawing
{
    pass P0
    {
        PixelShader = compile PS_SHADERMODEL MainPS();
    }
};